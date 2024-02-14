#!/bin/bash
IMAGE_NAME=lab2_prediction
APP_NAME=lab2_prediction

# Run pytest within poetry virtualenv
poetry env remove python3.10
poetry install
poetry run pytest -vv -s

# Check if the container is running, then stop and remove it
if [ ! -z "$(docker ps -q -f name=${APP_NAME})" ]; then
    echo "Stopping running container ${APP_NAME}..."
    docker stop ${APP_NAME}
else
    echo "No running container ${APP_NAME} to stop."
fi

if [ ! -z "$(docker ps -a -q -f name=${APP_NAME})" ]; then
    echo "Removing container ${APP_NAME}..."
    docker rm ${APP_NAME}
else
    echo "No existing container ${APP_NAME} to remove."
fi

# rebuild and run the new image
docker build -t ${IMAGE_NAME} .
docker run -d --name ${APP_NAME} -p 8000:8000 ${IMAGE_NAME}

# wait for the /health endpoint to return a 200 and then move on
finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/health")
    if [ $health_status == "200" ]; then
        finished=true
        echo "API is ready"
    else
        echo "API not responding yet"
        sleep 1
    fi
done

# check a few endpoints and their http response (lab1)
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar" # 200
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?nam=Winegar" # 422
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/" # 404
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs" # 200

# check the /predict endpoints with good and bad data

declare -A data_samples=(
  ["correct_input"]='{
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 1.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }'
  ["larger_bedroom_input"]='{
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 9.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }'
  ["missing_one_input"]='{
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": 1.0238095238095237,
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Longitude": -122.23
         }'
  ["string_input"]='{
         "MedInc": 8.3252,
         "HouseAge": 41.0,
         "AveRooms": 6.984126984126984,
         "AveBedrms": "string",
         "Population": 322.0,
         "AveOccup": 2.5555555555555554,
         "Latitude": 37.88,
         "Longitude": -122.23
         }'
)

for name in "${!data_samples[@]}"
do
  data=${data_samples[$name]}
  echo "Sending $name to /predict"
  curl -o /dev/null -s -w "%{http_code}\n" -H "Content-Type: application/json" -d "$data" -X POST "http://localhost:8000/predict"
done

# output logs for the container
docker logs ${APP_NAME}

# stop and remove container
docker stop ${APP_NAME}
docker rm ${APP_NAME}

# delete image
docker image rm ${APP_NAME}
