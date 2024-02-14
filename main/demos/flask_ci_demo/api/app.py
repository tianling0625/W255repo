from api.config import env_config
from flasgger import Swagger
from flask import Flask
from flask_cors import CORS
from flask_restful import Api

api = Api()


def create_app(config_name):
    app = Flask(__name__)

    app.config.from_object(env_config[config_name])
    api.init_app(app)

    CORS(app)

    app.config["SWAGGER"] = {
        "title": "W255 Demo API",
    }
    Swagger(app)

    return app
