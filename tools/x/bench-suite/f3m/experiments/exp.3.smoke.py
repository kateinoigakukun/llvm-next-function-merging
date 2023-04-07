#!/usr/bin/env python3
import harness.config as config
import harness.harness as harness
from harness.flags import Flags
from harness.bmarks import Benchmark


short_tests = [
    Benchmark.get_by_name(name) for name in [
        "470.lbm",
        "473.astar",
    ]
]

configuration = config.Configuration(
    llvm_dir=config.LLVM_DIR,
    llvm_pass_plugin=config.PASS_PLUGIN,
    output_dir=config._REPO_ROOTDIR / '.x' / 'bench-suite' / 'f3m' / 'output'
)

combos = [Flags.from_name(name, config=configuration)
          for name in ["baseline", "hyfm", "f3m", "mfm2"]]

harness.main({}, benchmarks=short_tests, experimental_combos=combos,
             repeats=1, config=configuration)
