import uuid
import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource
from Restaurants import Restaurants

class Favourite(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('favourite', metadata,
                                  sql.Column('uuid', sql.String, primary_key=True),
                                  sql.Column('restaurant_uuid', sql.String),
                                  sql.Column('client_uuid', sql.String))
        metadata.create_all(engine)

    def add(self):
        client_uuid = request.json['client_uuid']
        restaurant_uuid = request.json['restaurant_uuid']
        query = sql.insert(self.database)
        query = query.values(uuid=str(uuid.uuid4()),
                             restaurant_uuid=restaurant_uuid,
                             client_uuid=client_uuid)
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database.c.restaurant_uuid])
        query = query.where(self.database.c.client_uuid == client_uuid)
        data = self.connection.execute(query)
        result = {'data': [self.detail(list(i).pop()) for i in data.cursor]}
        return jsonify(result)

    def remove(self):
        client_uuid = request.json['client_uuid']
        restaurant_uuid = request.json['restaurant_uuid']
        query = sql.delete(self.database)
        query = query.where(self.database.c.restaurant_uuid == restaurant_uuid)
        query = query.where(self.database.c.client_uuid == client_uuid)
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database.c.restaurant_uuid])
        query = query.where(self.database.c.client_uuid == client_uuid)
        data = self.connection.execute(query)
        result = {'data': [self.detail(list(i).pop()) for i in data.cursor]}
        return jsonify(result)

    def getAll(self):
        client_uuid = request.args.get('client_uuid')
        query = sql.select([self.database.c.restaurant_uuid])
        query = query.where(self.database.c.client_uuid == client_uuid)
        data = self.connection.execute(query)
        result = {'data': [self.detail(list(i).pop()) for i in data.cursor]}
        return jsonify(result)

    def detail(self, uuid):
        restaurants = Restaurants()
        query = sql.select([restaurants.database])
        query = query.where(restaurants.database.c.uuid == uuid)
        data = restaurants.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            restaurant = result['data']
            restaurants.parse(restaurant)
            return restaurant
        else:
            return {}