#!/bin/bash
IMAGE_NAME=lab3:0.1
APP_NAME=lab3
PORT=8080

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
docker run -d --name temp-redis -p 6379:6379 redis
poetry run pytest -vv -s

# start Minikube
minikube start --kubernetes-version=v1.27.3

# Setup docker daemon
eval $(minikube docker-env)

# stop and remove image in case this script was run before
docker stop ${IMAGE_NAME}
docker rm ${IMAGE_NAME}

# rebuild and run the new image
docker build -t ${IMAGE_NAME} .
docker run -d --name ${APP_NAME} -p 8000:8000 ${IMAGE_NAME}

# Apply namespace
kubectl apply -f ./infra/namespace.yaml
# Set namespace
kubectl config set-context --current --namespace=w255
# Apply redis
kubectl apply -f ./infra/deployment-redis.yaml --namespace=w255
kubectl apply -f ./infra/service-redis.yaml --namespace=w255
# Apply api
kubectl apply -f ./infra/deployment-pythonapi.yaml --namespace=w255
kubectl apply -f ./infra/service-prediction.yaml --namespace=w255

# wait for the deployment to be ready
POD_NAME=""
# wait for 5 seconds for the pod to be created
echo "waiting for pod to be created..."
sleep 0
while [ -z "$POD_NAME" ]; do
    POD_NAME=$(kubectl get pods --namespace=w255 -l app=pythonapi -o jsonpath="{.items[0].metadata.name}" 2>/dev/null)
    if [ -z "$POD_NAME" ]; then
        echo "waiting for pod name to be retriev"
        sleep 1
    fi
done

while [[ $(kubectl get pods $POD_NAME --namespace=w255 -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "Waiting Pod $POD_NAME to be ready."
    sleep 3
done

# check if the port is available, if not, increment by 1 
while true; do
    nc -z localhost $PORT
    if [ $? -eq 0 ]; then
        echo "PORT $PORT is occupied, trying next one..."
        ((PORT++))
    else
        echo "PORT $PORT is available."
        break
    fi
done
# port forward the service to localhost
kubectl port-forward svc/service-prediction $PORT:8000 --namespace=w255 &
PF_PID=$!

# wait for the /health endpoint to return a 200 and then move on
finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:$PORT/health")
    if [ $health_status == "200" ]; then
        finished=true
        echo "API is ready"
    else
        echo "API not responding yet"
        sleep 1
    fi
done

# check a few endpoints and their http response
echo "Checking endpoints"
echo "------------------"
echo "GET /health (should return 200)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:$PORT/hello?name=Winegar"
echo "GET /hello?nam=Winegar (should return 422)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:$PORT/hello?nam=Winegar"
echo "GET / (should return 404)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:$PORT/"
echo "GET /docs (should return 200)"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:$PORT/docs"
echo "POST /predict (should return 200)"
curl -o /dev/null -s -w "%{http_code}\n" -X POST "http://localhost:$PORT/predict" -H 'Content-Type: application/json' -d '{
    "MedInc": 1,
    "HouseAge": 1,
    "AveRooms": 3,
    "AveBedrms": 3,
    "Population": 3,
    "AveOccup": 5,
    "Latitude": 1,
    "Longitude": 1
}'
echo "POST /bulk_predict (should return 200)"
curl -o /dev/null -s -w "%{http_code}\n" -X POST "http://localhost:$PORT/bulk_predict" -H 'Content-Type: application/json' -d '{
    "houses": [
    {
      "MedInc": 1,
      "HouseAge": 1,
      "AveRooms": 3,
      "AveBedrms": 3,
      "Population": 3,
      "AveOccup": 5,
      "Latitude": 1,
      "Longitude": 1
    },
    {
      "MedInc": 2,
      "HouseAge": 2,
      "AveRooms": 4,
      "AveBedrms": 4,
      "Population": 4,
      "AveOccup": 6,
      "Latitude": 2,
      "Longitude": 2
    }
  ]
}'
echo "all done"
echo "--------"

# output logs for the container
docker logs ${APP_NAME}

# stop and remove container
docker stop ${APP_NAME}
docker rm ${APP_NAME}

# delete image
docker image rm ${IMAGE_NAME}

# delete all resources in the w255 namespace
kubectl delete all --all --namespace=w255

# delete the w255 namespace
kubectl delete namespace w255

# kill the port-forward process
kill $PF_PID

# stop Minikube
minikube stop