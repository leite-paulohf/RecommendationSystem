from flask import request
from flask_restful import Resource
from sqlalchemy import create_engine

class Usage(Resource):

    def __init__(self):
        self.engine = create_engine('sqlite:///database.db')

    def post(self):
        database = self.engine.connect()
        print(request.json)
        user_id = request.json['user_id']
        name = request.json['name']
        date = request.json['date']
        time = request.json['time']
        time_id = request.json['time_id']
        kind = request.json['kind']
        kind_id = request.json['kind_id']
        discount = request.json['discount']
        city = request.json['city']
        city_id = request.json['city_id']
        neighbourhood = request.json['neighbourhood']
        neighbourhood_id = request.json['neighbourhood_id']
        cuisine = request.json['cuisine']
        cuisine_id = request.json['cuisine_id']
        price_range = request.json['price_range']
        rating = request.json['rating']
        categories = request.json['categories']
        categories_id = request.json['categories_id']
        moments = request.json['moments']
        moments_id = request.json['moments_id']
        query = "INSERT INTO usage values(null,'{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}','{15}','{16}','{17}','{18}','{19}','{20}')"
        database.execute(query.format(user_id, name, date, time, time_id, kind, kind_id, discount, city, city_id, neighbourhood, neighbourhood_id, cuisine, cuisine_id, price_range, rating, categories, categories_id, moments, moments_id))
        return {'status': '201'}
