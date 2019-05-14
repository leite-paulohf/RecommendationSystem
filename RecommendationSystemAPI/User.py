from flask import jsonify
from flask_restful import Resource
from sqlalchemy import create_engine

class User(Resource):

    def __init__(self):
        self.engine = create_engine('sqlite:///database.db')

    def get(self, user_id):
        database = self.engine.connect()
        query = "SELECT user_id FROM usages WHERE user_id = {}".format(user_id)
        data = database.execute(query)
        result = {'data': dict(zip(tuple (data.keys()) ,i)) for i in data.cursor }
        return jsonify(result)