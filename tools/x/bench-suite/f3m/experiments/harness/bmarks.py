'''This module encapsulates the basic usage of Benchmarks and Benchmark Suites.
This includes things like retrieving Benchmarks, building them with arbitrary
options and cleaning their directories'''

import os
import time
import datetime
import subprocess
import pathlib
import tempfile
import shutil
from distutils.dir_util import copy_tree

import harness.config as config
from harness.flags import Flags

class Benchmark(object):
    '''Mostly an interface with the Makefiles. Builds, cleans, measures
       time, and returns the output binary name. Contains no experiment
       specific logic'''

    _bmarks = dict()

    def __init__(self, name, basedir, suite_name):
        self.name = name
        self.basedir = basedir
        self.suite_name = suite_name

    def __hash__(self):
        return hash(self.basedir.resolve())

    def _execute(self, cmd, stdout, stderr, config: config.Configuration = None):
        env = {}
        if config:
            env = {'LLVM_NEXTFM_PLUGIN': str(config.llvm_pass_plugin)}
        return subprocess.run(
            cmd,
            stdout=stdout, stderr=stderr,
            cwd=self.basedir,
            check=True, universal_newlines=True,
            env=env)

    def _execute_make(self, args, flags: Flags, stdout, stderr):
        cmd = ['/usr/bin/make']
        cmd.extend(args)
        cmd.extend(flags.mkfile_opts())
        cmd.append(f'BUILD_DIR={self.build_dir(flags.config)}')
        return [self._execute(cmd, stdout, stderr, flags.config), cmd]

    def binary_name(self, flags):
        '''Returns the relative path of the binary created by the Makefile'''
        res, _ = self._execute_make(['name_bin'], flags, subprocess.PIPE, None)
        return res.stdout.strip()

    def binary_file(self, flags):
        '''Returns the path of the binary created by the Makefile'''
        return self.basedir / self.binary_name(flags)

    def binary_size(self, flags):
        '''Returns the size of the binary created by the Makefile'''
        return os.stat(self.binary_file(flags)).st_size

    def object_name(self, flags):
        '''Returns the relative path of the obj file created by the Makefile'''
        res, _ = self._execute_make(['name_obj'], flags, subprocess.PIPE, None)
        return res.stdout.strip()

    def object_size(self, flags):
        '''Returns the size of the object file created by the Makefile'''
        filename = self.basedir / self.object_name(flags)
        return os.stat(filename).st_size

    def object_text_size(self, flags):
        '''Returns the size of the obj file text area'''
        llvm_size = pathlib.Path(flags.llvm_dir()) / 'llvm-size'
        cmd = [llvm_size, self.object_name(flags)]
        res = self._execute(cmd, subprocess.PIPE, None)
        data = res.stdout.strip().split('\n')[1]
        return data.split()[0]

    def logpath(self, kind, flags: Flags):
        '''Returns the path where the output of the experiment will be saved'''
        flags_str = str(flags).replace(' ', '.')
        timestamp = datetime.datetime.now().isoformat()
        log = flags.config.logs_dir() / f'{kind}.{self.name}.{flags_str}.{timestamp}.log'
        remark = flags.config.remarks_dir() / f'{kind}.{self.name}.{flags_str}.{timestamp}.yaml'
        return log, remark

    def build_dir(self, config: config.Configuration):
        '''Returns the path where the benchmark will be built'''
        return config.output_dir / "build" / self.suite_name / self.name

    def build(self, flags: Flags):
        '''Build the benchmark with the selected flags'''
        self.build_dir(flags.config).mkdir(parents=True, exist_ok=True)

        log, remark = self.logpath('build', flags)
        log.parent.mkdir(parents=True, exist_ok=True)
        remark.parent.mkdir(parents=True, exist_ok=True)
        
        with open(log, 'w') as fout:
            args = [f'REMARK_PATH={remark}']
            start = time.perf_counter()
            _, cmd = self._execute_make(args, flags, fout, subprocess.STDOUT)
            end = time.perf_counter()
        return {'cmd': cmd,
                'runtime': end-start,
                'object_size': self.object_size(flags),
                'remark': remark,
                'log': log}

    def runnable(self):
        '''Quick check to determine whether this benchmark can be executed'''
        if self.suite_name == 'spec2006' or self.suite_name == 'spec2017':
            return True
        return False

    def run(self, flags):
        '''Run (and if necessary build) the benchmark with the selected flags'''
        if self.suite_name == 'spec2006':
            src = config.BMARK_DIR / 'spec2006-data' / self.name
        elif self.suite_name == 'spec2017':
            src = config.BMARK_DIR / 'spec2017-data' / self.name / 'run'
        else:
            return None

        binary_path = self.basedir / self.binary_name(flags)
        print(f"Running {self.name} with {flags} from {binary_path}")
        res_build = None
        if not binary_path.exists():
            res_build = self.build(flags)

        with tempfile.TemporaryDirectory(prefix='hsfm') as tmpdirname:
            copy_tree(src, tmpdirname)
            shutil.copy(binary_path, tmpdirname)
            if self.name == '625.x264_s':
                subprocess.run(
                    ['/bin/sh', './simple-build-ldecod_r-525.sh'],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    cwd=self.basedir / 'src')
                subprocess.run(
                    [self.basedir / 'src' / 'ldecod_r',
                     '-i',
                     'BuckBunny.264',
                     '-o',
                     'BuckBunny.yuv'],
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    cwd=tmpdirname)

            log, _ = self.logpath('run', flags)
            with open(log, 'w') as fout:
                cmd = ['/bin/sh', './run.sh', f'./{binary_path.name}']
                start = time.perf_counter()
                subprocess.run(
                    cmd,
                    stdout=fout, stderr=subprocess.STDOUT,
                    cwd=tmpdirname,
                    check=True, universal_newlines=True)
                end = time.perf_counter()

        res = {'cmd': cmd, 'runtime': end-start, 'log': log}
        return res_build, res

    def clean(self):
        '''Remove intermediate build files'''
        cmd = ['/usr/bin/make', 'clean']
        self._execute(cmd, subprocess.DEVNULL, subprocess.DEVNULL)

    @classmethod
    def get_all(cls):
        '''Returns all registered benchmarks'''
        return cls._bmarks.values()

    @classmethod
    def get_by_suite(cls, suite):
        '''Get all benchmarks contained in this suite'''
        suite_obj = BenchmarkSuite.get_by_name(suite)
        if suite_obj:
            return suite_obj.benchmarks
        return None

    @classmethod
    def get_by_name(cls, name):
        '''Get any benchmark with this name'''
        # If the name matches a object name, return it
        if name in cls._bmarks:
            return cls._bmarks[name]
        # If the name matches the part of the object
        # name after the first period, return it
        keys = [key for key in cls._bmarks if key.partition('.')[2] == name]
        if len(keys) == 1:
            return cls._bmarks[keys[0]]
        if len(keys) > 1:
            raise Exception('Too many benchmarks with the same name')
        return None

    @classmethod
    def register_all(cls):
        '''Register all individual benchmarks'''
        for suite in BenchmarkSuite.get_all():
            for benchmark in suite:
                cls._bmarks[benchmark.name] = benchmark

class BenchmarkSuite(object):
    '''Just a collection of Benchmarks'''

    _suites = dict()

    def __init__(self, name, basedir, patterns):
        self.name = name
        self.basedir = basedir
        self.benchmarks = []
        self._idx = 0
        if not patterns:
            self.benchmarks = [Benchmark(name, basedir, name)]
        else:
            for pattern in patterns:
                for benchmark in sorted(basedir.glob(pattern)):
                    if not benchmark.is_dir():
                        continue
                    self.benchmarks.append(Benchmark(benchmark.name, benchmark, name))

    def __hash__(self):
        return hash(self.basedir.resolve())

    def __iter__(self):
        self._idx = 0
        return self

    def __next__(self):
        if self._idx >= len(self.benchmarks):
            raise StopIteration
        retval = self.benchmarks[self._idx]
        self._idx += 1
        return retval

    @classmethod
    def get_all(cls):
        '''Return all benchmark suites'''
        return cls._suites.values()

    @classmethod
    def get_by_name(cls, name):
        '''Return all benchmarks suites with the given name'''
        # If the name matches a object name, return it
        if name in cls._suites:
            return cls._suites[name]
        return None

    @classmethod
    def register_all(cls):
        '''Using the config info, register all benchmark suites'''
        for entry in config.BMARK_SUITES:
            basedir = config.BMARK_DIR / entry['name']
            suite = BenchmarkSuite(entry['name'], basedir, entry['pattern'])
            cls._suites[suite.name] = suite

BenchmarkSuite.register_all()
Benchmark.register_all()
