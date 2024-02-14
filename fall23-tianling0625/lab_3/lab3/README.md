# README

## Documentation

1. What this application does
   - runs a simple `FastAPI` API with uvicorn as the async webworker
   - The API has endpoints for returning `hello {NAME}` and healthchecking
   - The API has endpoints for returning  the median of the house value from eight dimensions of data based on model trained from The California housing dataset
   - The API has endpoints for returning the bulk prediction of the house values from a list of eight dimensions of data based on model trained from The California housing dataset
2. How to build your application
   - `docker build -t lab3:0.1 .`
3. How to run your application
   - `./run.sh`
4. How to test your application
   - `poetry run pytest`
5. Endpoints:
`/hello`: Accepts a query parameter name and returns a JSON message greeting the user by the inputted name. If the name parameter is not specified, it returns an appropriate HTTP error status.

`/`: Returns a "Not Found" message along with the corresponding HTTP status code.

`/docs`: Allows users to browse the API documentation while the API is running.

`/openapi.json`: Provides a JSON object that meets the OpenAPI specification version 3+ and is browsable while the API is running.

`/health`: Returns a JSON object with the status of the API.

`/predict`: Accepts a JSON payload with eight dimensions of data and returns a JSON object with the median house value prediction.

`/bulk_predict`: Accepts a JSON payload with a list of eight dimensions of data and returns a JSON object with the median house value predictions.

## Q&A

 1. What are the benefits of caching?

    Caching is a way to store data in a temporary storage area. It can reduce network traffic and latency. In this project, it is used to store the output data from the model, so that the API can return the output data directly from the cache without calling the model again if the input data is the same.

 2. What is the difference between Docker and Kubernetes?
    
    Docker is a containerization platform that allows developers to package applications into containers. Kubernetes is an open-source container orchestration platform that automates the deployment, scaling, and management of containerized applications. In this project, Docker is used to build and run the application, while Kubernetes is used to deploy the application.

 3. What does a kubernetes deployment do?

    A Kubernetes deployment is used to tell Kubernetes how to create or modify instances of the pods that hold a containerized application. It includes the container image to run, the number of copies of the container to run, and the resources that should be allocated to each container. In this project, it is used to deploy the application.

 4. What does a kubernetes service do?

    A Kubernetes service is to connect a set of pods to an abstracted service name and IP address. It can also expose the service to external traffic. 