#!/usr/bin/env python3

import argparse
import os
from glob import glob
import numpy as np
import yaml
from yaml import CLoader as Loader
import sqlite3


class Passed(yaml.YAMLObject):
    yaml_loader = Loader
    yaml_tag = "!Passed"

    def __init__(self, Pass, Name, Function, Args):
        self.Pass = Pass
        self.Name = Name
        self.Function = Function
        self.Args = Args

    def is_n_merge(self, n):
        if not self.Name == "Merge":
            return False
        funcs = 0
        for arg in self.Args:
            if "Function" in arg:
                funcs += 1
        return funcs == n

    def funcs(self):
        for arg in self.Args:
            if "Function" in arg:
                yield arg["Function"]

    def passed(self):
        return self.Name == "Merge"

    def function(self):
        return self.Args[0]["Function"]

class Missed(yaml.YAMLObject):
    yaml_loader = Loader
    yaml_tag = "!Missed"

    def __init__(self, Name):
        self.Name = Name

class DataSource:
    def y_labels(self):
        return sorted(self.data.keys())

    def __baseline_case_name(self):
        return "TECHNIQUE=baseline"

    def variants(self):
        variants = set(self.data[self.y_labels()[0]].keys())
        return sorted(variants - {"TECHNIQUE=hyfm"} - {self.__baseline_case_name()}, reverse=True)

    def plotting_value(self, bmark, case_name):
        if not case_name in self.data[bmark]:
            return None 
        return 100 * (1 - self.data[bmark][case_name] / self.data[bmark][self.__baseline_case_name()])

    def succeeded(self, bmark, case_name):
        return self.data[bmark][case_name] != 0

    def title(self):
        return self.__class__.__name__

    def xlabel(self):
        raise NotImplementedError()

class ObjSizeDataSource(DataSource):
    def __init__(self, conn):
        self.conn = conn
        data = {}
        for row in self.conn.execute("SELECT benchmark, flags, size FROM builds"):
            bmark, flags, size = row
            if bmark not in data:
                data[bmark] = {}
            data[bmark][flags] = size
        self.data = data

    def title(self):
        return "Object size reduction rate compared to baseline"
    def xlabel(self):
        return "Object size reduction (%)"

class MergedFunctionsDataSource(DataSource):
    def __init__(self, conn):
        data = {}
        import multiprocessing
        with multiprocessing.Pool() as pool:
            rows = conn.execute("SELECT benchmark, flags, remark FROM builds").fetchall()
            results = pool.imap_unordered(self.__class__.load_row, rows)
            for idx, (bmark, flags, count) in enumerate(results):
                print(f"[{idx} / {len(rows)}]: {bmark} {flags} {count}]")
                if bmark not in data:
                    data[bmark] = {}
                data[bmark][flags] = count
        self.data = data

    @classmethod
    def load_row(cls, row):
        bmark, flags, remark = row
        with open(remark, "r") as f:
            count = cls.load_remark_content(f)
            return (bmark, flags, count)

    @classmethod
    def load_remark_content(cls, remark_file):
        remarks = yaml.load_all(remark_file, Loader=Loader)
        if not remarks:
            return 0
        source_n_by_merged_name = {}
        for remark in remarks:
            if not isinstance(remark, Passed) or not remark.passed():
                continue
            sources = 0
            for func in remark.funcs():
                if func not in source_n_by_merged_name:
                    sources += 1
                else:
                    sources += source_n_by_merged_name[func]
                    del source_n_by_merged_name[func]
            source_n_by_merged_name[remark.function()] = sources
        total_sources = 0
        for _, sources in source_n_by_merged_name.items():
            total_sources += sources
        return total_sources

    def plotting_value(self, bmark, case_name):
        if not case_name in self.data[bmark]:
            return None 
        return self.data[bmark][case_name]

    def title(self):
        return "Number of merged input functions"
    def xlabel(self):
        return "Number of merged input functions"

class CompileTimeDataSource(DataSource):
    def __init__(self, conn):
        self.conn = conn

    def data(self):
        data = {}
        for row in self.conn.execute("SELECT benchmark, flags, runtime FROM builds"):
            bmark, flags, time = row
            if bmark not in data:
                data[bmark] = {}
            data[bmark][flags] = time
        return data

class Plotter:

    def __init__(self, options):
        self.options = options

    def plot_value(self, result, case_name, baseline):
        v = result.data[case_name]
        if baseline:
            v = 100 * (1 - v / baseline.data[case_name])
        return v

    def plot(self, data_source: DataSource, colors, ax):
        fontsize = self.options.fontsize
        bmarks = data_source.y_labels()
        variants = data_source.variants()

        bench_space = 0.3
        bar_width = (1 - bench_space) / len(variants)
        x = np.arange(len(bmarks))
        values_by_variant = []

        for idx, variant in enumerate(variants):
            x_pos = x + idx * bar_width - (len(bmarks) - 1) * bar_width/2
            values = []
            bar_labels = []
            for bmark in bmarks:
                v = data_source.plotting_value(bmark, variant)
                if v:
                    values.append(v)
                    bar_labels.append("{v:.3f}".format(v=v))
                else:
                    values.append(0)
                    bar_labels.append("failure")

            rect = ax.barh(x_pos, values, bar_width, label=variant, color=colors[idx])
            ax.bar_label(rect, padding=3, labels=bar_labels, fontsize=fontsize)
            values_by_variant.append(values)

        hans, labs = ax.get_legend_handles_labels()
        ax.legend(handles=hans[::-1], labels=labs[::-1], fontsize=fontsize)

        ax.axvline(0, color="black", linewidth=0.5)
        ax.set_title(data_source.title(), fontsize=fontsize + 6)
        ax.set_xlabel(data_source.xlabel(), fontsize=fontsize)
        ax.set_yticks(x, bmarks, fontsize=fontsize)


def main():
    parser = argparse.ArgumentParser(
        description="Plot the results of the benchmark")
    parser.add_argument("result", type=str, nargs='?', default="./.x/bench-suite/f3m/f3m-cgo22-artifact.v4/results.db")
    parser.add_argument("-o", "--output", type=str, default=None)
    parser.add_argument("--baseline", type=str)
    parser.add_argument("--exclude-failures", action="store_true")
    parser.add_argument("--exclude-zeros", action="store_true")
    parser.add_argument("--fontsize", type=int, default=11)
    parser.add_argument("--target", type=str, default="objsize")

    options = parser.parse_args()
    import matplotlib.pyplot as plt
    fig, ax = plt.subplots(figsize=(15, 10))
    plotter = Plotter(options)
    colors = [plt.get_cmap('Paired')(idx) for idx in (1, 2, 3, 4, 5, 7, 9, 11)]

    data_sources = {
        "objsize": ObjSizeDataSource,
        "compiletime": CompileTimeDataSource,
        "merges": MergedFunctionsDataSource,
    }
    with sqlite3.connect(options.result) as conn:
        data_source_class = data_sources[options.target]
        data_source = data_source_class(conn)
        plotter.plot(data_source, colors, ax)
    fig.tight_layout()

    output = options.output or f".x/bench-suite/f3m/plot_{options.target}.png"
    plt.savefig(output)
    print("Plot saved to {}".format(output))


if __name__ == "__main__":
    main()
