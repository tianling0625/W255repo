#!bin/bash

# 1.Build the docker container
echo "##### Building docker container"
docker build -t greeting_api -f lab1/Dockerfile lab1/

# 2.Run the docker container in detached mode and get container id
echo "##### Running docker container in detached mode"
container_id=$(docker run -d -p 8000:8000 greeting_api)

# 3. Wait until the container is running
echo "##### Waiting for the container to start..."
sleep 10

# 4. Curl the defined endpoints and return status codes
echo "----- Testing '/hello' endpoint with ?name=Winegar"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar"

echo "----- Testing '/hello' endpoint with missing name parameter"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name="

echo "----- Testing '/hello' endpoint with missing parameter"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?"

echo "----- Testing '/' endpoint"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/"

echo "----- Testing '/docs' endpoint"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs"

echo "----- Testing '/openapi.json' endpoint"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/openapi.json"

# 5. Kill the container
echo "##### Killing container"
docker kill $container_id

# 6. Delete the container
echo "##### Deleting container"
docker rm $container_id