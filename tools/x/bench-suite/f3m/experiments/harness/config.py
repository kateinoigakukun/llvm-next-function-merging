import pathlib
import subprocess
from dataclasses import dataclass

_BASEDIR = pathlib.Path(__file__).parent.resolve()
_REPO_ROOTDIR = pathlib.Path(
    subprocess.check_output(
        ["/usr/bin/git", "rev-parse", "--show-toplevel"], cwd=_BASEDIR).decode('utf-8').strip()
)

LLVM_DIR = _BASEDIR.parent / 'llvm-fakebin'
BMARK_DIR = _REPO_ROOTDIR.joinpath(
    "..", "llvm-nextfm-benchmark", 'benchmarks').resolve()

_DEFAULT_PASS_PLUGIN = _REPO_ROOTDIR / '.x' / 'build' / \
    'RelWithDebInfo' / 'lib' / 'LLVMNextFM.so'

BMARK_SUITES = [
    {'name': 'spec2006', 'pattern': ['4*.*']},
    {'name': 'spec2017', 'pattern': ['5*.*', '6*.*']},
    {'name': 'cc1plus', 'pattern': []},
    {'name': 'chrome', 'pattern': []},
    {'name': 'libreoffice', 'pattern': []},
    {'name': 'linux', 'pattern': []},
    {'name': 'llvm', 'pattern': []}, ]


@dataclass
class Configuration:
    dbpath: pathlib.Path
    output_dir: pathlib.Path
    llvm_pass_plugin: pathlib.Path = _DEFAULT_PASS_PLUGIN
    llvm_dir: pathlib.Path = _BASEDIR.parent / 'llvm-fakebin'

    debug: bool = False
    verbose: bool = False

    def logs_dir(self):
        return self.output_dir / 'logs'

    def remarks_dir(self):
        return self.output_dir / 'remarks'
