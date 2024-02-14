import joblib
import pandas as pd
from flask import Flask, Response, jsonify, request
from flask_api import status

app = Flask(__name__)

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
