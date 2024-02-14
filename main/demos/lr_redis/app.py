import ast

import numpy as np
import redis
from flask import Flask, jsonify, request
from scipy.special import expit

app = Flask(__name__)
cache = redis.Redis("localhost")


def logistic(x, weights):
    z = sum(x * weights)
    return expit(z)


@app.route("/update", methods=["POST"])
def update():
    json_ = request.json
    cache.set("weights", str(json_))
    weights = np.array(
        list(ast.literal_eval(cache.get("weights").decode("UTF-8")).values())
    )
    return jsonify({"weights": [int(weight) for weight in weights]})


@app.route("/predict", methods=["POST"])
def predict():
    json_ = request.json
    weights = np.array(
        list(ast.literal_eval(cache.get("weights").decode("UTF-8")).values())
    )
    predictions = [logistic(data, weights) for data in json_]
    return jsonify(
        {"prediction": predictions, "weights": [int(weight) for weight in weights]}
    )
