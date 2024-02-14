from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, confloat, field_validator, ValidationInfo, ValidationError
from datetime import datetime
import os
import joblib

app = FastAPI()

# Load pre-trained model
model_filename = "model_pipeline.pkl"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
model_path = os.path.join(BASE_DIR, 'model_pipeline.pkl')
model = joblib.load(model_path)

class HousePredictionInput(BaseModel):
    # Add field with constrain
    MedInc: confloat(ge=0)
    HouseAge: confloat(ge=0)
    AveRooms: confloat(ge=0)
    AveBedrms: confloat(ge=0)
    Population: confloat(ge=0)
    AveOccup: confloat(ge=0)
    Latitude: confloat(ge=-90, le=90)
    Longitude: confloat(ge=-180, le=180)
    
    @field_validator("AveBedrms")
    @classmethod
    def bedrooms_not_more_than_rooms(cls, AveBedrms: float,info: ValidationInfo) -> float:
        averoom = info.data["AveRooms"]
        if AveBedrms > averoom:
            raise ValueError('Number of bedrooms cannot exceed number of rooms')
        return AveBedrms


class HousePredictionOutput(BaseModel):
    predicted_price: float


@app.get("/health")
async def health():
    current_time = datetime.now().isoformat()
    return {"time": current_time}


# Raises 422 if bad parameter automatically by FastAPI
@app.get("/hello")
async def hello(name: str):
    return {"message": f"Hello {name}"}


# /docs endpoint is defined by FastAPI automatically
# /openapi.json returns a json object automatically by FastAPI


@app.post("/predict", response_model=HousePredictionOutput)
async def predict_price(data: HousePredictionInput):
    input_data = [[
        data.MedInc, data.HouseAge, data.AveRooms, data.AveBedrms,
        data.Population, data.AveOccup, data.Latitude, data.Longitude
    ]]
    
    predicted = model.predict(input_data)[0]
    # return {"message":f"shape {input_data.shape}"}
    return {"predicted_price": predicted}