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

    def __init__(self, Name, Args):
        self.Name = Name
        self.Args = Args

    def is_n_merge(self, n):
        if not self.Name == "Merge":
            return False
        funcs = 0
        for arg in self.Args:
            if "Function" in arg:
                funcs += 1
        return funcs == n


class Missed(yaml.YAMLObject):
    yaml_loader = Loader
    yaml_tag = "!Missed"

    def __init__(self, Name):
        self.Name = Name

class DataSource:
    def x_labels(self):
        return sorted(self.data.keys())

    def baseline_case_name(self):
        return "TECHNIQUE=baseline"

    def variants(self):
        variants = set(self.data[self.x_labels()[0]].keys())
        return sorted(variants - {"TECHNIQUE=hyfm"} - {self.baseline_case_name()}, reverse=True)

    def plotting_value(self, bmark, case_name):
        if not case_name in self.data[bmark]:
            return None 
        return 100 * (1 - self.data[bmark][case_name] / self.data[bmark][self.baseline_case_name()])

    def succeeded(self, bmark, case_name):
        return self.data[bmark][case_name] != 0

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
        bmarks = data_source.x_labels()
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
        ax.set_title(
            "Object size reduction rate compared to baseline", fontsize=fontsize + 6)
        ax.set_xlabel("Reduction rate in size (%)", fontsize=fontsize)
        ax.set_xlabel("Object size reduction (%)", fontsize=fontsize)
        ax.set_yticks(x, bmarks, fontsize=fontsize)


def main():
    parser = argparse.ArgumentParser(
        description="Plot the results of the benchmark")
    parser.add_argument("result", type=str, nargs='?', default="./.x/bench-suite/f3m/f3m-cgo22-artifact.v4/results.db")
    parser.add_argument("-o", "--output", type=str, default=".x/bench-suite/f3m/plot.png")
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
    with sqlite3.connect(options.result) as conn:
        result = ObjSizeDataSource(conn)
        plotter.plot(result, colors, ax)
    fig.tight_layout()
    plt.savefig(options.output)
    print("Plot saved to {}".format(options.output))


if __name__ == "__main__":
    main()
