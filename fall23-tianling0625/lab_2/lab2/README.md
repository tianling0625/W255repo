# README

## Documentation

1. What this application does
   - runs a simple `FastAPI` API with uvicorn as the async webworker
   - The API has endpoints for returning `hello {NAME}` and healthchecking
   - The API has endpoints for returning  the median of the house value from eight dimensions of data based on model trained from The California housing dataset
2. How to build your application
   - `docker build -t lab2_prediction .`
3. How to run your application
   - `./run.sh`
4. How to test your application
   - `poetry run pytest`

## Q&A

 1. What does Pydantic handle for us?

    Pydantic is a Python library for data parsing and validation. In this project, it mainly handles data inputs validation.
 2. What do Docker 'HEALTHCHECK' s do?

    Docker HEALTHCHECK are instructions for Docker to periodically check the running application inside a container to ensure it's working as expected. It detects whether a resource is healthy by indicators of "starting", "healthy", and "unhealthy".
 3. Describe what the Sequence Diagram below shows.

   The sequence diagram below shows the interaction between a user, an API, and a model. The diagram has the following steps:
   - The user sends a POST JSON payload to the API, which contains the input values for the model.

   - The API validates the input payload against a pydantic schema, which defines the data types and constraints for the input values.

   - If the input payload does not satisfy the schema, the API returns an error message to the user, indicating what went wrong.

   - If the input payload satisfies the schema, the API passes the input values to the model, which performs some computation and returns the output values.

   - The API store the returned values from model.

   - The API returns the output values as output data to the user.
    
