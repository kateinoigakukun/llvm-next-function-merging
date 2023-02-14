#!/usr/bin/env python
import harness.config as config
import harness.harness as harness
from harness.flags import Flags

global_flags = {
    'benchmarks': ['spec2006'],
    'execute': False,
    'verbose': False,
    'debug': False,
    'from_scratch': False,
    'report': False,
    'llvm_dir': config.LLVM_DIR}

combos = Flags.get_standard()

harness.main(global_flags, experimental_combos=combos, repeats=1)
