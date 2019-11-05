import datetime
import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource
from jbuilder.restaurant import RestaurantBuilder
from query.enum import Query


class Usages(Resource):

    def __init__(self):
        self.builder = RestaurantBuilder()
        self.engine = sql.create_engine('sqlite:///database.db', echo=True)
        self.connection = self.engine.connect()

    def create(self):
        query = self.query(Query.create_usage.value)
        params = {"event_time": datetime.datetime.now(),
                  "chairs": request.json['chairs'],
                  "client_id": request.json['client_id'],
                  "restaurant_id": request.json['restaurant_id']}
        self.request(query, params)
        query = self.query(Query.usages.value)
        params = {"client_id": request.json['client_id']}
        data = self.request(query, params)
        if 'error' in data:
            return jsonify(data)
        else:
            return self.builder.restaurants(data)

    def list(self):
        query = self.query(Query.usages.value)
        params = {"client_id": request.args.get('client_id')}
        data = self.request(query, params)
        if 'error' in data:
            return jsonify(data)
        else:
            return self.builder.restaurants(data)

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
