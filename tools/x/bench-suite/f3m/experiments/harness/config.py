import pathlib


_BASEDIR = pathlib.Path(__file__).parent.resolve()
_REPO_ROOTDIR = pathlib.Path(__file__).parent.parent.parent.parent.parent.parent.parent
_ORIGINAL_BASEDIR = _REPO_ROOTDIR.joinpath("..", "llvm-nextfm-benchmark").resolve()

LLVM_DIR = _BASEDIR.parent / 'llvm-fakebin'
LOGDIR = _ORIGINAL_BASEDIR / 'logs'
REAMRKDIR = _ORIGINAL_BASEDIR / 'remarks'
BMARK_DIR = _ORIGINAL_BASEDIR / 'benchmarks'

DBPATH = _ORIGINAL_BASEDIR / 'results.db'

PASS_PLUGIN = _REPO_ROOTDIR / '.x' / 'build' / 'RelWithDebInfo' / 'lib' / 'LLVMNextFM.so'

BMARK_SUITES = [
        {'name': 'spec2006', 'pattern': ['4*.*']},
        {'name': 'spec2017', 'pattern': ['5*.*', '6*.*']},
        {'name': 'cc1plus', 'pattern': []},
        {'name': 'chrome', 'pattern': []},
        {'name': 'libreoffice', 'pattern': []},
        {'name': 'linux', 'pattern': []},
        {'name': 'llvm', 'pattern': []},]
