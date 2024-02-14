#!/bin/bash

ACR_DOMAIN=w255mids.azurecr.io
ACR_NAME=w255mids
REPOSITORY_NAME=twang0
IMAGE_NAME=project

COMMIT_HASH=$(git rev-parse --short HEAD)

# build the image
docker build -t $IMAGE_NAME:$COMMIT_HASH .

# tag the image
docker tag $IMAGE_NAME:$COMMIT_HASH ${ACR_DOMAIN}/${REPOSITORY_NAME}/$IMAGE_NAME:$COMMIT_HASH

# login to acr
az acr login --name $ACR_NAME

# push image
docker push ${ACR_DOMAIN}/$REPOSITORY_NAME/$IMAGE_NAME:$COMMIT_HASH


# Kubernetes Deployment

DEPLOYMENT_NAME=project
NAMESPACE=twang0
CONTAINER_NAME=project

# update image
kubectl set image deployment/$DEPLOYMENT_NAME $CONTAINER_NAME=${ACR_DOMAIN}/$REPOSITORY_NAME/$IMAGE_NAME:$COMMIT_HASH -n $NAMESPACE
