import os
import numpy as np
from fastapi import FastAPI
from joblib import load
from pydantic import BaseModel, ConfigDict, Field
from typing import List

from starlette.requests import Request
from starlette.responses import Response

from fastapi_cache import FastAPICache
from fastapi_cache.backends.redis import RedisBackend
from fastapi_cache.decorator import cache

from redis import asyncio as aioredis


app = FastAPI()

async def startup_event():
    global model
    model = load("model_pipeline.pkl")  # Load model

    # Set up the Redis cache backend
    redis_host = os.environ.get('REDIS_HOST', 'localhost')
    redis_port = os.environ.get('REDIS_PORT', 6379)
    redis_url = f"redis://{redis_host}:{redis_port}"
    redis = await aioredis.from_url(redis_url)
    FastAPICache.init(RedisBackend(redis), prefix="fastapi-cache")

app.router.add_event_handler("startup", startup_event)


# Use pydantic.Extra.forbid to only except exact field set from client.
# This was not required by the lab.
# Your test should handle the equivalent whenever extra fields are sent.
class House(BaseModel):
    """Data model to parse the request body JSON."""

    model_config = ConfigDict(extra="forbid")

    MedInc: float = Field(gt=0)
    HouseAge: float
    AveRooms: float
    AveBedrms: float
    Population: float
    AveOccup: float
    Latitude: float
    Longitude: float

    def to_np(self):
        return np.array(list(vars(self).values())).reshape(1, 8)


class HousePrediction(BaseModel):
    model_config = ConfigDict(extra="forbid")
    prediction: float

# New BulkHouseRequest for accepting a list of House inputs
class BulkHouse(BaseModel):
    houses: List[House]
    def to_np(self):
        return np.array([house.to_np().flatten() for house in self.houses])

# New response model for bulk predictions
class BulkHousePrediction(BaseModel):
    predictions: List[float]

@app.post("/predict", response_model=HousePrediction)
# @cache(expire=60)  # Cache for 60 seconds
async def predict(house: House):
    prediction = model.predict(house.to_np())[0]
    return {"prediction": prediction}


# New endpoint for bulk predictions
@app.post("/bulk_predict", response_model=BulkHousePrediction)
@cache(expire=60)  # Cache for 60 seconds
async def bulk_predict(houses: BulkHouse):
    predictions = model.predict(houses.to_np())
    return {"predictions": predictions.tolist()}
    # return BulkHousePrediction(predictions=predictions.tolist())


@app.get("/health")
async def health():
    return {"status": "healthy"}


# Raises 422 if bad parameter automatically by FastAPI
@app.get("/hello")
async def hello(name: str):
    return {"message": f"Hello {name}"}


# /docs endpoint is defined by FastAPI automatically
# /openapi.json returns a json object automatically by FastAPI
