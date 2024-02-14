# FastAPI Application

## Overview

This application is a FastAPI project that provides features with several endpoints including:

`/hello`: Accepts a query parameter name and returns a JSON message greeting the user by the inputted name. If the name parameter is not specified, it returns an appropriate HTTP error status.

`/`: Returns a "Not Found" message along with the corresponding HTTP status code.

`/docs`: Allows users to browse the API documentation while the API is running.

`/openapi.json`: Provides a JSON object that meets the OpenAPI specification version 3+ and is browsable while the API is running.

## How the application was built

- Set up working environment by installing Python 3.10, Poetry, and other necessary dependencies.
- Create a lab_1 folder and initialize a new poetry project using the command `poetry new lab1 --name src`. 
- Add the necessary dependencies (FastAPI, Uvicorn) and development dependencies (pytest, httpx, ruff, black) using poetry.
- Develop the API with all the endpoints mentioned above and test the API using pytest with different test cases including valid and invalid inputs.

## How to run the application

- Locally: Run the command `uvicorn src.main:app` to start the API. The API will be hosted and accessible on port 8000 on the local machine.
- Using Docker: Build a Docker image using the command `docker build -t greeting_api .` and then run it using `docker run -d -p 8000:8000 greeting_api`. The API will be hosted and accessible on port 8000 on the local machine.


## How to test the application

- Locally: Run the command `pytest` to run all the tests in the tests folder. Create test suites using pytest in the `test_main.py` file to ensure that all endpoints respond correctly to both correct and incorrect inputs. The tests cover a variety of values and any other tests that demonstrate the API's functionality.
- Using Docker: Run the command `docker run -it greeting_api pytest` to run all the tests in the tests folder. 
- Utilize the `run.sh` bash script to automate the testing process. This script builds and runs the Docker container, tests the defined endpoints using curl commands, and then cleans up by killing and deleting the container. Run the script using the commands `bash run.sh` or `./run.sh`.


<br><br><br>


# Short Answers to Questions

- **What status code should be raised when a query parameter does not match our expectations?**
    - If the query parameter does not match our expectations, we should raise a 422 Unprocessable Entity error. This is because the request is syntactically correct but semantically incorrect. The request was understood by the server but could not be processed due to semantic errors. In this case, the semantic error is that the query parameter does not match our expectations.

- **What does Python Poetry handle for us?**
    - Poetry handles dependency management and packaging in this project. It allows us to specify the dependencies of our project and then install them all at once. It also allows us to create a virtual environment for our project and manage the dependencies within that environment. Poetry also allows us to package our project into a Docker image.

- **What advantages do multi-stage docker builds give us?**
    - Multi-stage docker builds allows us to build our image in a temporary container and then copy the necessary files from that container into a new container. When we have both a built and deploy stages, we can use the built stage to build our application and then use the deploy stage to copy the built application into a new container. This allows us to have a smaller final image size because we do not need to include the build tools in the final image. This also allows us to have a more secure final image because we do not need to include the build tools in the final image.
