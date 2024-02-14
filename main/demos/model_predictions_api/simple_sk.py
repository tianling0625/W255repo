import joblib
import pandas as pd
from flask import Flask, jsonify, request

app = Flask(__name__)

clf = joblib.load("model.joblib")


@app.route("/predict", methods=["POST"])
def predict():
    json_ = request.json
    query_df = pd.DataFrame(json_)
    query = pd.get_dummies(query_df)
    print(query)
    prediction = clf.predict(query)
    return jsonify({"prediction": prediction.tolist()})
