from flask import jsonify
from flask_restful import Resource
from sqlalchemy import create_engine

class Restaurants(Resource):

    def __init__(self):
        self.engine = create_engine('sqlite:///database.db')

    def get(self):
        database = self.engine.connect()
        query = database.execute("SELECT DISTINCT name, kind, discount, city, neighbourhood, cuisine, price_range, rating, categories, moments FROM usage;")
        result = {'data': [dict(zip(tuple(query.keys()), i)) for i in query.cursor]}
        return jsonify(result)
