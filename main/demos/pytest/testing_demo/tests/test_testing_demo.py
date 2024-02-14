from fastapi.testclient import TestClient
from testing_demo import __version__
from testing_demo.main import app

client = TestClient(app)


def test_version():
    assert __version__ == "0.1.0"


def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}
