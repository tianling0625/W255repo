from api.app import api
from flask_restful import Resource


class DefaultResource(Resource):
    def get(self):
        return {"status": "success", "data": {"msg": "Hello World"}}


api.add_resource(DefaultResource, "/", endpoint="home")
