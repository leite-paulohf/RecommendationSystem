from flask import jsonify
from flask_restful import Resource
from sqlalchemy import create_engine

class Usages(Resource):

    def __init__(self):
        self.engine = create_engine('sqlite:///database.db')

    def get(self, user_id):
        database = self.engine.connect()
        query = database.execute("SELECT * FROM usage WHERE user_id =%d"  %int(user_id))
        result = {'data': [dict(zip(tuple (query.keys()) ,i)) for i in query.cursor]}
        return jsonify(result)
