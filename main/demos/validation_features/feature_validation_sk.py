import joblib
import pandas as pd
from flask import Flask, jsonify, request

app = Flask(__name__)

clf = joblib.load("model.pkl")
features = joblib.load("features.pkl")


@app.route("/predict", methods=["POST"])
def predict():
    json_ = request.json
    query = pd.get_dummies(pd.DataFrame(json_))

    if set(features) != set(query.columns):
        raise ValueError("Features do not match between API call and trained model")

    query = query.reindex(columns=features, fill_value=0)

    print(query)
    prediction = clf.predict(query)

    return jsonify({"prediction": prediction.tolist()})
