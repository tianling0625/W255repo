import joblib
import pandas as pd
from flask import Flask, Response, jsonify, request
from flask_api import status
from google.cloud import storage
from google.oauth2 import service_account

app = Flask(__name__)

key_path = "./w255-secrets-6f0343c21e1b.json"
credentials = service_account.Credentials.from_service_account_file(key_path)

storage_client = storage.Client(credentials=credentials)
bucket = storage_client.bucket("w255-model-bucket")

files = ["features.pkl", "pipe.pkl"]
for file in files:
    blob = bucket.blob(file)
    blob.download_to_filename(file)

clf = joblib.load("pipe.pkl")
features = joblib.load("features.pkl")


@app.route("/predict", methods=["POST"])
def predict():
    json_ = request.json
    query = pd.get_dummies(pd.DataFrame(json_))

    if set(features) != set(query.columns):
        return Response(
            "Features do not match between API call and trained model",
            status.HTTP_406_NOT_ACCEPTABLE,
        )

    query = query.reindex(columns=features, fill_value=0)

    print(query)
    prediction = clf.predict(query)

    return jsonify({"prediction": prediction.tolist()})
