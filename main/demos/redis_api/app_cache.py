import requests
from flask import Flask, jsonify, request
from flask_caching import Cache

app = Flask(__name__)
app.config.from_object("config.Config")
cache = Cache(app)  # Initialize Cache


@app.route("/age")
@cache.cached(timeout=120, query_string=True)
def get_age():
    API_URL = "https://api.agify.io/?name="
    search = request.args.get("name")
    r = requests.get(f"{API_URL}{search}")
    return jsonify(r.json())


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
