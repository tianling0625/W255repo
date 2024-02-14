from api.app import api
from flask_restful import Resource


class DefaultResource(Resource):
    def get(self):
        return {"status": "success", "data": {"msg": "Hello World"}}


class Username(Resource):
    def get(self, username):
        """
        This examples uses FlaskRESTful Resource
        It works also with swag_from, schemas and spec_dict
        ---
        parameters:
          - in: path
            name: username
            type: string
            required: true
        responses:
          200:
            description: A single user item
            schema:
              id: User
              properties:
                username:
                  type: string
                  description: The name of the user
                  default: Steven Wilson
        """
        return {"username": username}, 200


api.add_resource(DefaultResource, "/", endpoint="home")
api.add_resource(Username, "/username/<username>")
