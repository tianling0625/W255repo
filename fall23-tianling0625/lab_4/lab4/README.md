# How to Deploy the Application
## https://twang0.mids255.com/ has been deployed by Kustomize and Istio to AKS. No need to run any command to deploy the application.

Even though, a `deploy.sh` file has been created to deploy the application to AKS. It will get the short commit hash from the git CLI and then save that variable to then be used in your image build and then properly tag and push your image to the registry.

# Curl Requests to test the application

## 1. `predict` endpoint with `json` data
`
curl -X 'POST' 
  'https://twang0.mids255.com/predict' 
  -H 'accept: application/json' 
  -H 'Content-Type: application/json' 
  -d '{
  "MedInc": 1,
  "HouseAge": 0,
  "AveRooms": 0,
  "AveBedrms": 0,
  "Population": 0,
  "AveOccup": 0,
  "Latitude": 0,
  "Longitude": 0
}'
`

## 2. `bulk_predict` endpoint with `json` data

`
curl -X 'POST' 
  'https://twang0.mids255.com/bulk_predict' 
  -H 'accept: application/json' 
  -H 'Content-Type: application/json' 
  -d '{
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
      "Longitude": -118
    }
  ]
}'
`

# Short-Answer Questions

## 1. What are the downsides of using `latest` as your docker image tag?

> There are a few downsides to using latest as your Docker image tag:

>> Insecurity: The latest tag is always the most recent image that has been pushed to the repository, which means that it is not guaranteed to be stable or secure. 

>> Unpredictability: The latest tag can change at any time, which means that the image that your container is running can change at any time. This can cause unexpected behavior in your application.

>> Performance: If you are using the latest tag, Docker will need to download the image every time it is not cached locally. This can slow down your builds and deployments.

## 2. What does `kustomize` do for us?

> Kustomize introduces a template-free way to customize application configuration that simplifies the use of off-the-shelf applications. It allows us to reuse one base file across all of the environments (development, staging, production) and then overlay unique specifications for each. Different environments can have different configurations, but the base configuration is the same.



