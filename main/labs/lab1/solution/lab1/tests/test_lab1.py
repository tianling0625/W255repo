import pytest
from fastapi.testclient import TestClient

from src import __version__
from src.main import app

client = TestClient(app)


def test_version():
    assert __version__ == "0.1.0"


def test_hello_bad_parameter():
    response = client.get("/hello?bob=name")
    assert response.status_code == 422


def test_root():
    response = client.get("/")
    assert response.status_code == 404
    assert response.json() == {"detail": "Not Found"}


@pytest.mark.parametrize(
    "test_input, expected",
    [("james", "james"), ("bob", "bob"), ("BoB", "BoB"), (100, 100)],
)
def test_hello(test_input, expected):
    response = client.get(f"/hello?name={test_input}")
    assert response.status_code == 200
    assert response.json() == {"message": f"Hello {expected}"}


def test_docs():
    response = client.get("/docs")
    assert response.status_code == 200


def test_hello_multiple_parameter_with_good_and_bad():
    response = client.get("/hello?name=james&bob=name")
    assert response.status_code == 200
    assert response.json() == {"message": "Hello james"}
