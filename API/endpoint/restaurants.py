import sqlalchemy as sql
from flask import request, jsonify
from flask_restful import Resource
from sqlalchemy import exc
from jbuilder.restaurant import RestaurantBuilder
from query.enum import Query


class Restaurants(Resource):

    def __init__(self):
        self.builder = RestaurantBuilder()
        self.engine = sql.create_engine('sqlite:///database.db')
        self.connection = self.engine.connect()

    def list(self):
        query = self.query(Query.restaurants.value)
        params = {"city_id": request.args.get('city_id')}
        data = self.request(query, params)
        if 'error' in data:
            return jsonify(data)
        else:
            return self.builder.restaurants(data)

    def show(self, restaurant_id):
        query = self.query(Query.restaurant.value)
        params = {"restaurant_id": restaurant_id}
        data = self.request(query, params)
        if 'error' in data:
            return jsonify(data)
        else:
            return self.builder.restaurant(data.pop())

    def query(self, file):
        fd = open(file, 'r')
        query = fd.read()
        fd.close()
        return query

    def request(self, query, params=None):
        try:
            data = self.connection.execute(query, params)
            if data.cursor is not None:
                return [dict(zip(tuple(data.keys()), i)) for i in data.cursor]
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
