#!/bin/bash

IMAGE_NAME=lab3
APP_NAME=lab3
NAMESPACE=w255

cd ${APP_NAME}

if [[ ${MINIKUBE_TUNNEL_PID:-"unset"} != "unset" ]]; then
    echo "Potentially existing Minikube Tunnel at PID: ${MINIKUBE_TUNNEL_PID}"
    kill ${MINIKUBE_TUNNEL_PID}
fi

# poetry env remove python3.11
# poetry install

FILE=./model_pipeline.pkl
if [ -f ${FILE} ]; then
    echo "${FILE} exist."
else
    echo "${FILE} does not exist."
    poetry run python ../trainer/train.py
    cp ../trainer/${FILE} .
fi

# poetry run pytest -vv -s

minikube delete
minikube start --kubernetes-version=v1.27.3 --memory 4096 --cpus 4
minikube addons enable metrics-server

# rebuild and run the new image within the minikube context
eval $(minikube docker-env)
docker build -t ${IMAGE_NAME} .

# apply yamls for building environment
kubectl apply -f infra/namespaces.yaml
kubectl wait --for=jsonpath='{.status.phase}'=Active namespace/${NAMESPACE}
kubectl apply -f infra/

kubectl wait deployment -n ${NAMESPACE} ${APP_NAME} --for condition=Available=True --timeout=90s
exit_status=$?
if [ $exit_status -ne 0 ]; then
    echo "Deployment failed to launch before timeout, please review"
    exit
fi

minikube tunnel &
export MINIKUBE_TUNNEL_PID=$!
# wait for the /health endpoint to return a 200 and then move on
finished=false
while ! $finished; do
    health_status=$(curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/health")
    if [ $health_status == "200" ]; then
        finished=true
        echo "API is ready"
    else
        echo "API not responding yet"
        sleep 5
    fi
done

curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?name=Winegar"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/hello?nam=Winegar"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/"
curl -o /dev/null -s -w "%{http_code}\n" -X GET "http://localhost:8000/docs"
curl -X POST "http://localhost:8000/predict" -H 'Content-Type: application/json' -d '{
    "MedInc": 1,
    "HouseAge": 0,
    "AveRooms": 0,
    "AveBedrms": 0,
    "Population": 0,
    "AveOccup": 0,
    "Latitude": 0,
    "Longitude": 0
}'
curl -X POST "http://localhost:8000/bulk_predict" -H 'Content-Type: application/json' -d '{
  "houses": [
    {
      "MedInc": 1,
      "HouseAge": 0,
      "AveRooms": 0,
      "AveBedrms": 0,
      "Population": 0,
      "AveOccup": 0,
      "Latitude": 0,
      "Longitude": 0
    },
    {
      "MedInc": 1,
      "HouseAge": 0,
      "AveRooms": 0,
      "AveBedrms": 0,
      "Population": 0,
      "AveOccup": 0,
      "Latitude": 0,
      "Longitude": 0
    }
  ]
}'

# output and tail the logs for the api deployment
kubectl logs -n ${NAMESPACE} -l app=${APP_NAME}

# cleanup
kubectl delete -f infra

kill ${MINIKUBE_TUNNEL_PID}
