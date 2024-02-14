#!/bin/bash
IMAGE_NAME=lab2
APP_NAME=lab2

# Create poetry environment and train model using environment
# move model to the src directory to be picked up by Docker
poetry env remove python3.11
poetry install

FILE=./model_pipeline.pkl
if [ -f ${FILE} ]; then
    echo "${FILE} exist."
else
    echo "${FILE} does not exist."
    poetry run python ../trainer/train.py
    cp ../trainer/${FILE} .
fi

# Run pytest within poetry virtualenv
poetry run pytest -vv -s

# stop and remove image in case this script was run before
docker stop ${APP_NAME}
docker rm ${APP_NAME}

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

# check a few endpoints and their http response
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?nam=Winegar"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs"
curl -o /dev/null -s -w "%{http_code}\n" -X POST "http://localhost:8000/predict" -H 'Content-Type: application/json' -d '{
    "MedInc": 1,
    "HouseAge": 1,
    "AveRooms": 3,
    "AveBedrms": 3,
    "Population": 3,
    "AveOccup": 5,
    "Latitude": 1,
    "Longitude": 1
}'

# output logs for the container
docker logs ${APP_NAME}

# stop and remove container
docker stop ${APP_NAME}
docker rm ${APP_NAME}

# delete image
docker image rm ${APP_NAME}
