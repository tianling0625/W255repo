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


################
## predict endpoint test
################

correct_input = {
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 1.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }

negative_input = {
         "MedInc": -8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 1.0238095238095237,
         "Population": 322.0,
         "AveOccup": -2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }

larger_bedroom_input = {
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 9.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }


missing_one_input = {
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 1.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Longitude": -122.23
         }

string_input = {
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": "string",
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }

## Correct input
def test_predict_correct_input():
    response = client.post("/predict", json=correct_input)
    assert response.status_code == 200

## incorrect input
def test_negative_input():
    response = client.post("/predict", json=negative_input)
    assert response.status_code == 422

def test_larger_bedroom_input():
    response = client.post("/predict", json=larger_bedroom_input)
    assert response.status_code == 422

def test_missing_one_input():
    response = client.post("/predict", json=missing_one_input)
    assert response.status_code == 422

## other values
def test_string_input():
    response = client.post("/predict", json=string_input)
    assert response.status_code == 422