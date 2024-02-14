from demo import __version__
from demo.main import entry


def test_version():
    assert __version__ == "0.2.0"


def test_entry():
    assert entry() == "1.4.1"
