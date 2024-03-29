#!/usr/bin/env python3

import argparse
import datetime
import subprocess
import sqlite3
import time

import harness.config as config
from .bmarks import Benchmark
from .flags import Flags

def db_init(config: config.Configuration):
    con = sqlite3.connect(str(config.dbpath))
    con.execute('''
        CREATE TABLE IF NOT EXISTS invocations (
            timestamp INTEGER PRIMARY KEY,
            revision TEXT,
            datetime TEXT,
            flags TEXT)''')

    con.execute('''
        CREATE TABLE IF NOT EXISTS builds (
            benchmark TEXT,
            revision TEXT,
            flags TEXT,
            runtime FLOAT,
            size INTEGER,
            log TEXT,
            remark TEXT,
            timestamp INTEGER)''')

    con.execute('''
        CREATE TABLE IF NOT EXISTS runs (
            benchmark TEXT,
            revision TEXT,
            flags TEXT,
            runtime FLOAT,
            log TEXT,
            timestamp INTEGER)''')

    con.execute('''
        CREATE TABLE IF NOT EXISTS reports (
            benchmark TEXT,
            revision TEXT,
            flags TEXT,
            runtime FLOAT,
            log TEXT,
            timestamp INTEGER)''')

    return con

def git_revision():
    return subprocess.check_output(
        ["/usr/bin/git", "rev-parse", "HEAD"]).decode('utf-8')

class Exp():
    def __init__(self, benchmarks, config: config.Configuration, experimental_combos=None, repeats=1, timeout=5*60*60, register=True):
        self.repeats = repeats
        self.timeout = timeout
        if experimental_combos:
            self.combos = experimental_combos
        else:
            self.combos = Flags.get_standard()

        self.revision = git_revision()
        self.benchmarks = benchmarks
        self.timestamp = int(time.time())
        self.timestamp_txt = datetime.datetime.now().isoformat()
        self.con = db_init(config=config)

        self.stats = dict()
        self.table = None
        self.config = config

    def _init_stats(self):
        # Retrieve the experiments history
        with self.con:
            sqlcmd = 'SELECT benchmark, revision, flags, runtime FROM ' + self.table
            for bmark, revision, flags, runtime in self.con.execute(sqlcmd):
                bmark = Benchmark.get_by_name(bmark)
                flags = Flags.from_str(flags, config=self.config)
                self._update_stats(bmark, revision, flags, runtime)

    def is_complete(self, bmark: Benchmark, flags):
        revision = self.revision
        print(f"Checking if {bmark.name} {flags} is complete")
        print(f"  {bmark} in stats: {bmark in self.stats}")
        if bmark not in self.stats:
            return False
        print(f"  {flags} in stats: {flags in self.stats[bmark]}")
        if flags not in self.stats[bmark]:
            return False
        if revision not in self.stats[bmark][flags]:
            return False
        print(f"  Checking time: {self.stats[bmark][flags][revision]['time']} > {self.timeout}")
        if self.stats[bmark][flags][revision]['time'] > self.timeout:
            return True
        print(f"  Checking count: {self.stats[bmark][flags][revision]['count']} >= {self.repeats}")
        if self.stats[bmark][flags][revision]['count'] >= self.repeats:
            return True
        return False

    def do_all(self):
        for flags in self.combos:
            for bmark in self.benchmarks:
                for idx in range(self.repeats):
                    if self.is_complete(bmark, flags):
                        break
                    print(idx, bmark.name, flags)
                    res = self.do_one(bmark, flags)
                    if res is None:
                        continue
                    self.write_results(bmark, flags, res)

    def write_results(self, bmark, flags, res):
        self._update_stats(bmark, self.revision, flags, res['runtime'])
        with self.con:
            if 'object_size' in res and self.table != 'reports':
                self.con.execute("INSERT INTO " + self.table + " values (?, ?, ?, ?, ?, ?, ?, ?)", (
                    bmark.name,
                    self.revision,
                    str(flags),
                    float(res['runtime']),
                    res['object_size'],
                    str(res['log']),
                    str(res['remark']),
                    self.timestamp))
            else:
                self.con.execute("INSERT INTO " + self.table + " values (?, ?, ?, ?, ?, ?)", (
                    bmark.name,
                    self.revision,
                    str(flags),
                    float(res['runtime']),
                    str(res['log']),
                    self.timestamp))


    def _update_stats(self, bmark, revision, flags, runtime):
        if bmark not in self.stats:
            self.stats[bmark] = dict()

        if flags not in self.stats[bmark]:
            self.stats[bmark][flags] = dict()

        if revision not in self.stats[bmark][flags]:
            self.stats[bmark][flags][revision] = {'count': 0, 'time': 0.0}

        self.stats[bmark][flags][revision]['count'] += 1
        self.stats[bmark][flags][revision]['time'] += runtime

    def do_one(self, bmark, flags):
        raise NotImplementedError

class BuildExp(Exp):
    def __init__(self, benchmarks, **kwargs):
        super().__init__(benchmarks, **kwargs)
        self.table = 'builds'
        self._init_stats()

    def do_one(self, bmark: Benchmark, flags):
        try:
            return self._do_one(bmark, flags)
        except subprocess.CalledProcessError:
            return None

    def _do_one(self, bmark: Benchmark, flags):
        return bmark.build(flags)

class RunExp(Exp):
    def __init__(self, benchmarks, **kwargs):
        super().__init__(benchmarks, **kwargs)
        # Could have inherited from BuildExp and
        #  do the building through super().do_one()
        #  but that would complicate the stats keeping
        self.builder = BuildExp(benchmarks, **kwargs, register=False)
        self.table = 'runs'
        self._init_stats()

    def do_one(self, bmark, flags):
        if not bmark.runnable():
            return None
        try:
            res_build, res_run = self._do_one(bmark, flags)
            if res_build is not None:
                self.builder.write_results(bmark, flags, res_build)
            return res_run
        except subprocess.CalledProcessError as e:
            print("Error while running benchmark", bmark.name, flags)
            print(e)
            return None

    def _do_one(self, bmark, flags):
        return bmark.run(flags)

class ReportExp(Exp):
    def __init__(self, benchmarks, **kwargs):
        super().__init__(benchmarks, **kwargs)
        self.table = 'reports'
        self._init_stats()

    def do_one(self, bmark, flags):
        return bmark.build(flags)

def main(config: config.Configuration, benchmarks = Benchmark.get_all(), experimental_combos=None, repeats=1, timeout=5*60*60):
    BuildExp(
        benchmarks,
        experimental_combos=experimental_combos,
        repeats=repeats,
        timeout=timeout,
        config=config
    ).do_all()


if __name__ == '__main__':
    PARSER = argparse.ArgumentParser(description='Process experimental options')
    PARSER.add_argument('benchmarks', metavar='BMARKS', type=str, nargs='*', default=None, help='Benchmarks to be used')
    PARSER.add_argument('-v', '--verbose', action='store_true', default=False, help='Control whether to produce verbose messages during function merging')
    PARSER.add_argument('-d', '--debug', action='store_true', default=False, help='Control whether to produce debug messages during function merging')
    PARSER.add_argument('-s', '--from_scratch', action='store_true', default=True, help='Produce bitcode files from scratch')
    PARSER.add_argument('-r', '--report', action='store_true', default=False, help='Produce a detailed alignment report for all possible function pairs')
    PARSER.add_argument('-l', '--llvm_dir', metavar='DIR', type=str, default=config.LLVM_DIR, help='Directory where the llvm binaries are located')
    main(vars(PARSER.parse_args()))
