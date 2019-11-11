import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource
from jbuilder.restaurant import RestaurantBuilder
from query.enum import Query


class Preference(Resource):

    def __init__(self):
        self.builder = RestaurantBuilder()
        self.engine = sql.create_engine('sqlite:///database.db', echo=True)
        self.connection = self.engine.connect()

    def add(self):
        query = self.query(Query.add_preference.value)
        params = {"client_id": request.json['client_id'],
                  "restaurant_id": request.json['restaurant_id'],
                  "like": request.json['like']}
        data = self.request(query, params)
        return jsonify(data)

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
