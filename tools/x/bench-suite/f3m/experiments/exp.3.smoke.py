#!/usr/bin/env python3
import harness.config as config
import harness.harness as harness
from harness.flags import Flags


short_tests = [
    "470.lbm",
    "473.astar",
]

global_flags = {
    'benchmarks': short_tests,
    'execute': False,
    'verbose': False,
    'debug': False,
    'from_scratch': False,
    'report': False,
    'output': config._REPO_ROOTDIR / '.x' / 'bench-suite' / 'f3m' / 'output',
    'llvm_dir': config.LLVM_DIR}

combos = [Flags.from_name(name)
          for name in ["baseline", "hyfm", "f3m", "mfm2"]]

harness.main(global_flags, experimental_combos=combos, repeats=1)
