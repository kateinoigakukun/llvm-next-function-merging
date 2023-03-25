#!/usr/bin/env python3

import argparse
import os
from glob import glob
import numpy as np
import yaml
from yaml import CLoader as Loader
import sqlite3
import sys


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
    def default_bmarks(self):
        return sorted(self.data.keys())

    def baseline_case_name(self):
        return "TECHNIQUE=baseline"

    def default_variants(self):
        return [
            'TECHNIQUE=mfm4 ALIGNER=hyfm',
            'TECHNIQUE=mfm4',
            'TECHNIQUE=mfm3 ALIGNER=hyfm',
            'TECHNIQUE=mfm3',
            # 'TECHNIQUE=mfm2',
            # 'TECHNIQUE=mfm2 IDENTICAL_TYPE_ONLY=true',
            'TECHNIQUE=f3m',
            'TECHNIQUE=hyfm',
            # 'TECHNIQUE=f3m-legacy'
        ]

    def legend(self, variant):
        variant_to_legend = {
            'TECHNIQUE=mfm4': 'Multiple Function Merging N=4',
            'TECHNIQUE=mfm4 ALIGNER=hyfm': 'Multiple Function Merging N=4 (HyFM)',
            'TECHNIQUE=mfm3': 'Multiple Function Merging N=3',
            'TECHNIQUE=mfm3 ALIGNER=hyfm': 'Multiple Function Merging N=3 (HyFM)',
            'TECHNIQUE=mfm2': 'Multiple Function Merging N=2',
            'TECHNIQUE=mfm2 ALIGNER=hyfm': 'Multiple Function Merging N=2 (HyFM)',
            'TECHNIQUE=mfm2 IDENTICAL_TYPE_ONLY=true': 'Multiple Function Merging N=2 (identical types only)',
            'TECHNIQUE=f3m': 'F3M (Patched)',
            'TECHNIQUE=hyfm': 'HyFM',
            'TECHNIQUE=f3m-legacy': 'F3M (Original)'
        }
        return variant_to_legend[variant]

    def plotting_value(self, bmark, case_name):
        if not case_name in self.data[bmark]:
            return None
        return 100 * (1 - self.data[bmark][case_name] / self.data[bmark][self.baseline_case_name()])

    def succeeded(self, bmark, case_name):
        return self.data[bmark][case_name] != 0

    def title(self):
        return self.__class__.__name__

    def xlabel(self):
        raise NotImplementedError()

    def stats(self):
        baseline = self.baseline_case_name()
        baseline_sizes = [self.data[bmark][baseline] for bmark in self.default_bmarks()]
        baseline_mean = np.mean(baseline_sizes)

        variant_width = 20
        for variant in self.default_variants():
            if len(variant) > variant_width:
                variant_width = len(variant)

        for variant in self.default_variants():
            sizes = []
            for bmark in self.default_bmarks():
                if not variant in self.data[bmark]:
                    continue
                sizes.append(self.data[bmark][variant])
            mean = np.mean(sizes)
            std = np.std(sizes)
            print(f"{variant:{variant_width}}: {(1 - sum(sizes) / sum(baseline_sizes)) * 100:.2f}%")
        print("\n\nMax reduction:")
        max_reduction = 0
        max_reduction_bmark = None
        for bmark in self.default_bmarks():
            f3m = 'TECHNIQUE=f3m'
            for variant in self.default_variants():
                if variant == f3m:
                    continue
                if not variant in self.data[bmark]:
                    continue
                baseline = self.data[bmark][self.baseline_case_name()]
                reduction = (self.data[bmark][f3m] - self.data[bmark][variant]) / baseline
                print(f"{bmark}: {variant} - {f3m} = {reduction}")
                if reduction > max_reduction:
                    max_reduction = reduction
                    max_reduction_bmark = bmark
        print(f"{max_reduction_bmark}: {max_reduction}%")

class PlottingOptions:
    def __init__(self):
        self.benchmarks = None
        self.variants = None
        self.figsize = (10, 8)
        self.fontsize = 11
        self.has_legend = lambda ds: True

    PRESETS = {
        'cgo2023-src': {
            'benchmarks': [
                '400.perlbench',
                '401.bzip2',
                '444.namd',
                '445.gobmk',
                '456.hmmer',
                '462.libquantum',
                '471.omnetpp',
                '483.xalancbmk'
            ],
            'variants': [
                'TECHNIQUE=mfm4',
                'TECHNIQUE=mfm3',
                'TECHNIQUE=mfm2',
                'TECHNIQUE=mfm2 IDENTICAL_TYPE_ONLY=true',
                'TECHNIQUE=f3m',
                'TECHNIQUE=f3m-legacy'
            ],
            'figsize': (10, 8),
            'fontsize': 11,
            'has_legend': lambda ds: isinstance(ds, ObjSizeDataSource),
        },
        'next': {
            'variants': [
                'TECHNIQUE=mfm4 ALIGNER=hyfm',
                'TECHNIQUE=mfm4',
                'TECHNIQUE=mfm3 ALIGNER=hyfm',
                'TECHNIQUE=mfm3',
                'TECHNIQUE=mfm2 ALIGNER=hyfm',
                'TECHNIQUE=mfm2',
                'TECHNIQUE=f3m',
                'TECHNIQUE=hyfm',
            ],
            'figsize': (20, 20),
            'fontsize': 11,
            'has_legend': lambda ds: True,
        }
    }

    @staticmethod
    def from_args(args, data_source: DataSource):
        opts = PlottingOptions()
        if args.preset:
            if not args.preset in PlottingOptions.PRESETS:
                print(
                    f"Unknown preset {args.preset}. Available presets: {', '.join(PlottingOptions.PRESETS.keys())}")
                sys.exit(1)
            opts.__dict__.update(PlottingOptions.PRESETS[args.preset])
        else:
            opts.__dict__.update(args.__dict__)
        if not opts.benchmarks:
            opts.benchmarks = data_source.default_bmarks()
        if not opts.variants:
            opts.variants = data_source.default_variants()
        return opts

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
            for idx, (bmark, flags, count, all_funcs) in enumerate(results):
                print(f"[{idx} / {len(rows)}]: {bmark} {flags} {count} / {all_funcs}")
                if bmark not in data:
                    data[bmark] = {}
                data[bmark][flags] = { "count": count, "all_funcs": all_funcs }
        self.data = data

    @classmethod
    def load_row(cls, row):
        bmark, flags, remark = row
        bc_file = cls.find_bc_file(bmark)
        if bc_file:
            all_funcs = cls.count_source_functions(bc_file)
        else:
            sys.stderr.write(f"WARNING: No bitcode file found for {bmark}\n")
            all_funcs = 0
        with open(remark, "r") as f:
            count = cls.load_remark_content(f)
            return (bmark, flags, count, all_funcs)

    @classmethod
    def count_source_functions(cls, bc_file):
        # Count the number of defined functions in the given bitcode file.
        import subprocess
        pass_plugin = os.path.join(os.path.dirname(__file__), "../../../../.x/build/RelWithDebInfo/lib/LLVMNextFM.so")
        json_bytes = subprocess.check_output([
            "opt-13", "-o", "/dev/null", "--passes=instcount2", bc_file,
            "--load", pass_plugin, "--load-pass-plugin", pass_plugin,
        ], stderr=subprocess.DEVNULL)
        import json
        json_str = json_bytes.decode("utf-8")
        json_obj = json.loads(json_str)
        return json_obj["instcount2.TotalFuncs"]

    @classmethod
    def find_bc_file(cls, bmark):
        path = f".x/bench-suite/f3m/f3m-cgo22-artifact.v4/benchmarks/**/{bmark}/**/_main_._all_._files_._linked_.bc"
        bc_files = glob(path, recursive=True)
        if len(bc_files) == 0:
            return None
        return bc_files[0]

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
        entry = self.data[bmark][case_name]
        return 100 * (float(entry["count"]) / float(entry["all_funcs"]))

    def stats(self):
        baseline = self.baseline_case_name()
        baseline_sizes = [self.data[bmark][baseline]["all_funcs"] for bmark in self.default_bmarks()]
        baseline_mean = np.mean(baseline_sizes)

        variant_width = 20
        for variant in self.default_variants():
            if len(variant) > variant_width:
                variant_width = len(variant)

        for variant in self.default_variants():
            sizes = [self.data[bmark][variant]["count"] for bmark in self.default_bmarks()]
            mean = np.mean(sizes)
            std = np.std(sizes)
            print(f"{variant:{variant_width}}: {(float(sum(sizes)) / sum(baseline_sizes)) * 100:.2f}%")

    def title(self):
        return "Percentage of merged functions in total functions"
    def xlabel(self):
        return "Percentage of merged functions (%)"

class CompileTimeDataSource(DataSource):
    def __init__(self, conn):
        data = {}
        for row in conn.execute("SELECT benchmark, flags, runtime FROM builds"):
            bmark, flags, time = row
            if bmark not in data:
                data[bmark] = {}
            data[bmark][flags] = time
        self.data = data

    def title(self):
        return "Compile time increase rate compared to baseline"

    def xlabel(self):
        return "Compile time (%)"

    def plotting_value(self, bmark, case_name):
        if not case_name in self.data[bmark]:
            return None
        return 100 * (self.data[bmark][case_name] / self.data[bmark][self.baseline_case_name()])

    def stats(self):
        baseline = self.baseline_case_name()
        baseline_sizes = [self.data[bmark][baseline] for bmark in self.default_bmarks()]
        baseline_mean = np.mean(baseline_sizes)

        variant_width = 20
        for variant in self.default_variants():
            if len(variant) > variant_width:
                variant_width = len(variant)

        for variant in self.default_variants():
            sizes = []
            for bmark in self.default_bmarks():
                if variant in self.data[bmark]:
                    sizes.append(self.data[bmark][variant])
            mean = np.mean(sizes)
            std = np.std(sizes)
            print(f"{variant:{variant_width}}: {-(1 - mean / baseline_mean) * 100:.2f}%")


class Plotter:

    def __init__(self, options: PlottingOptions):
        self.options = options

    def plot(self, data_source: DataSource, colors, ax):
        fontsize = self.options.fontsize
        bmarks = self.options.benchmarks
        variants = self.options.variants

        bench_space = 0.05
        bar_width = (1 - bench_space) / len(variants)
        y = np.arange(len(bmarks))

        for idx, variant in enumerate(variants):
            y_pos = y + idx * bar_width + bar_width/2 - bar_width * len(variants)/2
            values = []
            bar_labels = []
            for bmark in bmarks:
                v = data_source.plotting_value(bmark, variant)
                if v:
                    values.append(v)
                    bar_labels.append("{v:.3f}".format(v=v))
                else:
                    values.append(0)
                    bar_labels.append("no data")

            label = data_source.legend(variant)
            rect = ax.barh(y_pos, values, bar_width, label=label, color=colors[idx])
            ax.bar_label(rect, padding=3, labels=bar_labels, fontsize=fontsize)

        hans, labs = ax.get_legend_handles_labels()
        has_legend = self.options.has_legend
        if has_legend is not None and has_legend(data_source):
            ax.legend(handles=hans[::-1], labels=labs[::-1], fontsize=fontsize-2)

        ax.axvline(0, color="black", linewidth=0.5)
        ax.set_title(data_source.title(), fontsize=fontsize + 6)
        ax.set_xlabel(data_source.xlabel(), fontsize=fontsize)
        ax.set_yticks(y, bmarks, fontsize=fontsize)
        ax.grid(axis='x')
        ax.spines['right'].set_visible(False)

def plot(data_source, options, output):
    import matplotlib.pyplot as plt
    fig, ax = plt.subplots(figsize=options.figsize)
    plotter = Plotter(options)
    colors = [plt.get_cmap('Paired')(idx) for idx in (1, 2, 3, 4, 5, 7, 9, 11)]
    plotter.plot(data_source, colors, ax)
    fig.tight_layout()

    plt.savefig(output)
    print("Plot saved to {}".format(output))


def main():
    parser = argparse.ArgumentParser(
        description="Plot the results of the benchmark")
    parser.add_argument("result", type=str, nargs='?', default="./.x/bench-suite/f3m/f3m-cgo22-artifact.v4/results.db")
    parser.add_argument("-o", "--output", type=str, default=None)
    parser.add_argument("--baseline", type=str)
    parser.add_argument("--exclude-failures", action="store_true")
    parser.add_argument("--exclude-zeros", action="store_true")
    parser.add_argument("--fontsize", type=int, default=11)
    parser.add_argument("--target", type=str, default="all")
    parser.add_argument("--preset", type=str, default=None)

    options = parser.parse_args()

    all_data_sources = {
        "objsize": ObjSizeDataSource,
        "compiletime": CompileTimeDataSource,
        "merges": MergedFunctionsDataSource,
    }

    if options.target == "all":
        data_sources = all_data_sources.keys()
    else:
        data_sources = [options.target]

    if options.output and len(data_sources) > 1:
        print("Cannot specify output file with multiple targets")
        return

    with sqlite3.connect(options.result) as conn:
        for target in data_sources:
            data_source_class = all_data_sources[target]
            data_source = data_source_class(conn)
            output = options.output or f".x/bench-suite/f3m/plot_{target}.png"
            plot_options = PlottingOptions.from_args(options, data_source)
            plot(data_source, plot_options, output)
            data_source.stats()

if __name__ == "__main__":
    main()
