import random

from fastapi.testclient import TestClient

from src.main import app

client = TestClient(app)


# Are we able to make a basic prediction?
# Do I return the type I expect?
# we test the predition is only a particular type because model weights change as we retrain
# when model weights change we also change our results
# recommend to test the fundamental expectation and not the particular value
def test_predict_basic():
    data = {
        "MedInc": 1,
        "HouseAge": 1,
        "AveRooms": 3,
        "AveBedrms": 3,
        "Population": 3,
        "AveOccup": 5,
        "Latitude": 1,
        "Longitude": 1,
    }
    response = client.post(
        "/predict",
        json=data,
    )
    assert response.status_code == 200
    assert isinstance(response.json()["prediction"], float)


# Can I change the order of the message sent to the API?
# Python 3.7+ all dicts are ordered
# If we shuffle the keys then we have a new dict with the same data and should get the same prediction
def test_predict_order():
    base_message = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": 3,
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
        "Longitude": 8,
    }
    keys = list(base_message)
    # shuffle with a seed
    random.Random(42).shuffle(keys)

    # create new dictionary
    shuffled_message = {}
    for key in keys:
        shuffled_message[key] = base_message[key]

    # make sure the messages are not the same
    assert shuffled_message.keys != base_message.keys

    response_base = client.post(
        "/predict",
        json=base_message,
    )
    response_shuffled = client.post(
        "/predict",
        json=shuffled_message,
    )
    # compare predictions
    assert response_base.json()["prediction"] == response_shuffled.json()["prediction"]


# Add an extraneous feature
# Since we used pydantic.Extra.forbid this will return a 422 value_error.extra
def test_predict_extra_feature():
    data = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": 3,
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
        "Longitude": 8,
        "ExtraFeature": -1,
    }

    response = client.post(
        "/predict",
        json=data,
    )

    assert response.status_code == 422
    assert response.json()["detail"] == [
        {
            "type": "extra_forbidden",
            "loc": ["body", "ExtraFeature"],
            "msg": "Extra inputs are not permitted",
            "input": -1,
            "url": "https://errors.pydantic.dev/2.4/v/extra_forbidden",
        }
    ]


# Remove a feature
# pydantic should error since we're missing values
# This means our imputer actually never does anything
def test_predict_missing_feature():
    data = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": 3,
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
    }

    response = client.post(
        "/predict",
        json=data,
    )

    assert response.status_code == 422
    assert response.json()["detail"] == [
        {
            "type": "missing",
            "loc": ["body", "Longitude"],
            "msg": "Field required",
            "input": {
                "MedInc": 1,
                "HouseAge": 2,
                "AveRooms": 3,
                "AveBedrms": 4,
                "Population": 5,
                "AveOccup": 6,
                "Latitude": 7,
            },
            "url": "https://errors.pydantic.dev/2.4/v/missing",
        }
    ]


# When we send both extra and missing features what happens?
# We get a message for each field that fails validation and have a list of errors returned
def test_predict_missing_and_extra_feature():
    data = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": 3,
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
        "ExtraFeature": 9,
    }

    response = client.post(
        "/predict",
        json=data,
    )

    assert response.status_code == 422
    assert response.json()["detail"] == [
        {
            "type": "missing",
            "loc": ["body", "Longitude"],
            "msg": "Field required",
            "input": {
                "MedInc": 1,
                "HouseAge": 2,
                "AveRooms": 3,
                "AveBedrms": 4,
                "Population": 5,
                "AveOccup": 6,
                "Latitude": 7,
                "ExtraFeature": 9,
            },
            "url": "https://errors.pydantic.dev/2.4/v/missing",
        },
        {
            "type": "extra_forbidden",
            "loc": ["body", "ExtraFeature"],
            "msg": "Extra inputs are not permitted",
            "input": 9,
            "url": "https://errors.pydantic.dev/2.4/v/extra_forbidden",
        },
    ]


# If we send in a bad type do we fail validation?
# here we see a string should have been a float
def test_predict_bad_type():
    data = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": "I am wrong",
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
        "Longitude": 8,
    }

    response = client.post(
        "/predict",
        json=data,
    )

    assert response.status_code == 422
    assert response.json()["detail"] == [
        {
            "type": "float_parsing",
            "loc": ["body", "AveRooms"],
            "msg": "Input should be a valid number, unable to parse string as a number",
            "input": "I am wrong",
            "url": "https://errors.pydantic.dev/2.4/v/float_parsing",
        }
    ]


# If we send a string value that can be coersed we should be fine
# the network is sending over the message as a string which gets parsed
# So everything is a string at some point but is validated on data instantiation
# This is called deserialization
def test_predict_bad_type_only_in_format():
    data = {
        "MedInc": 1,
        "HouseAge": 2,
        "AveRooms": "3",
        "AveBedrms": 4,
        "Population": 5,
        "AveOccup": 6,
        "Latitude": 7,
        "Longitude": 8,
    }

    response = client.post(
        "/predict",
        json=data,
    )

    print(response.json())
    assert response.status_code == 200
    assert isinstance(response.json()["prediction"], float)
