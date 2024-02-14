# README

## Documentation

1. What this application does
   - runs a simple `FastAPI` API with uvicorn as the async webworker
   - The API has endpoints for returning `hello {NAME}` and healthchecking
2. How to build your application
   - `docker build -t lab1:latest .`
3. How to run your application
   - `./run.sh`
4. How to test your application
   - `poetry run pytest`

## Q&A

 1. What status code should be raised when a query parameter does not match our expectations?
    - 422
    - If we can't process the request then we raise 422 for a client error (user/consumer originated error) specifiyng the application does not under the provided parameters
 2. What does Python Poetry handle for us?
    - environment management
    - dependency traversal
    - environment definition
    - repeatable environment creation
 3. What advantages do multi-stage docker builds give us?
    - Smaller deployment images
    - Less redudency in builds
    - Secrets away from final image if required for build-time
    - Smaller security footprint
      - Build-time dependencies might have security risks but they're not in the final deployment image
