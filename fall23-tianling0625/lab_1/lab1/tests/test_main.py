from src.main import app
from fastapi.testclient import TestClient
import pytest
import time


client = TestClient(app)

####################
# Test that all endpoints respond correctly to the right inputs
####################

def test_hello_valid():
    response = client.get("/hello?name=Tim")
    assert response.status_code == 200
    assert response.json() == {"message": "hello Tim"}

# Test root endpoint
def test_root():
    response = client.get("/")
    assert response.status_code == 404
    assert response.json() == {"detail": "Not Found"}

# Test OpenAPI documentation served at /docs
def test_docs_content():
    response = client.get("/docs")
    assert response.status_code == 200
    assert "FastAPI" in response.text
    assert "<html" in response.text

# Test it returns a json object that meets the OpenAPI specification version 3+ when
# the /openapi.json endpoint is hit
def test_openapi_specification():
    response = client.get("/openapi.json")
    assert response.status_code == 200
    data = response.json()
    assert "openapi" in data
    assert data["openapi"].startswith("3.")


####################
#  Test that all endpoints respond correctly to the incorrect inputs
####################

# Test empty name
def test_hello_empty_string():
    response = client.get("/hello?name=")
    assert response.status_code == 422
    assert "detail" in response.json()

# Test missing name
def test_hello_missing_name():
    response = client.get("/hello")
    assert response.status_code == 422
    assert "detail" in response.json()


####################
#  Test the endpoints with a variety of values.
####################

# Test with a variety of different types of values and languages
@pytest.mark.parametrize("name", ["Tim", "你好", "Γεια σου", "123", "123.456", "true", "null", "[]", "{}"])
def test_hello_variety_of_types(name):
    response = client.get(f"/hello?name={name}")
    assert response.status_code == 200
    assert response.json() == {"message": f"hello {name}"}


####################
#  Other Tests
####################

# Test that the endpoint responds in less than 500ms
def test_stress_test():
    start_time = time.time()
    response = client.get("/hello?name=John")
    end_time = time.time()
    assert response.status_code == 200
    assert end_time - start_time < 0.5

# Test extremely long name
def test_hellot_long_input():
    long_name = "Tim" * 1001
    response = client.get(f"/hello?name={long_name}")
    assert response.status_code == 200