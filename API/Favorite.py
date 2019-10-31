import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource
from Restaurants import Restaurants


class Favorite(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table("favorites", metadata, autoload=True)

    def add(self):
        client_id = request.json['client_id']
        restaurant_id = request.json['restaurant_id']
        query = sql.insert(self.database)
        query = query.values(restaurant_id=restaurant_id,
                             client_id=client_id)
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database.c.restaurant_id])
        query = query.where(self.database.c.client_id == client_id)
        data = self.connection.execute(query)
        result = {'data': [self.detail(list(i).pop()) for i in data.cursor]}
        return jsonify(result)

    def remove(self):
        client_id = request.json['client_id']
        restaurant_id = request.json['restaurant_id']
        query = sql.delete(self.database)
        query = query.where(self.database.c.restaurant_id == restaurant_id)
        query = query.where(self.database.c.client_id == client_id)
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database.c.restaurant_id])
        query = query.where(self.database.c.client_id == client_id)
        data = self.connection.execute(query)
        result = {'data': [self.detail(list(i).pop()) for i in data.cursor]}
        return jsonify(result)

    def pagination(self, per_page, page):
        offset = page * per_page
        pagination = {
            "per_page": per_page,
            "page": page,
            "next_page": page + 1,
            "offset": offset
        }
        return pagination

    def getAll(self):
        client_id = request.args.get('client_id')
        page = int(request.args.get('page'))
        per_page = 25
        offset = page * per_page
        query = sql.select([self.database.c.restaurant_id])
        query = query.where(self.database.c.client_id == client_id)
        query = query.limit(per_page).offset(offset)
        data = self.connection.execute(query)
        result = {
            'data': {
                'pagination': self.pagination(per_page, page),
                'restaurants': [self.detail(list(i).pop()) for i in data.cursor]
            }
        }
        return jsonify(result)

    def detail(self, restaurant_id):
        restaurants = Restaurants()
        query = sql.select([restaurants.database])
        query = query.where(restaurants.database.c.id == restaurant_id)
        data = restaurants.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            restaurant = result['data']
            restaurants.parse(restaurant)
            return restaurant
        else:
            return {}
