import requests
from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route("/age")
def get_age():
    API_URL = "https://api.agify.io/?name="
    search = request.args.get("name")
    r = requests.get(f"{API_URL}{search}")
    return jsonify(r.json())


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
