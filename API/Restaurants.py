import sqlalchemy as sql
from flask import jsonify, request
from flask_restful import Resource

class Kind(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('kind', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class City(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('city', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class Neighbourhood(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('neighbourhood', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class Cuisine(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('cuisine', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class Category(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('category', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class Moment(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('moment', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']

class Restaurants(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('restaurant', metadata,
                                  sql.Column('uuid', sql.String, primary_key=True),
                                  sql.Column('name', sql.String),
                                  sql.Column('kind_id', sql.Integer),
                                  sql.Column('discount', sql.Integer),
                                  sql.Column('city_id', sql.Integer),
                                  sql.Column('neighbourhood_id', sql.Integer),
                                  sql.Column('cuisine_id', sql.Integer),
                                  sql.Column('price_range', sql.Integer),
                                  sql.Column('rating', sql.Integer),
                                  sql.Column('category_id', sql.Integer),
                                  sql.Column('moment_id', sql.Integer))
        metadata.create_all(engine)

    def parse(self, restaurant):
        kind_id = restaurant.pop('kind_id')
        kind = Kind().get(kind_id)
        restaurant['kind'] = kind

        city_id = restaurant.pop('city_id')
        city = City().get(city_id)
        restaurant['city'] = city

        neighbourhood_id = restaurant.pop('neighbourhood_id')
        neighbourhood = Neighbourhood().get(neighbourhood_id)
        restaurant['neighbourhood'] = neighbourhood

        cuisine_id = restaurant.pop('cuisine_id')
        cuisine = Cuisine().get(cuisine_id)
        restaurant['cuisine'] = cuisine

        category_id = restaurant.pop('category_id')
        category = Category().get(category_id)
        restaurant['category'] = category

        moment_id = restaurant.pop('moment_id')
        moment = Moment().get(moment_id)
        restaurant['moment'] = moment

        return restaurant

    def getAll(self):
        city_id = request.args.get('city_id')
        query = sql.select([self.database])
        query = query.where(self.database.c.city_id == city_id)
        data = self.connection.execute(query)
        result = {'data': [dict(zip(tuple(data.keys()), i)) for i in data.cursor]}
        if bool(result):
            restaurants = result['data']
            for restaurant in restaurants:
                self.parse(restaurant)
            return jsonify(restaurants)
        else:
            return jsonify([])

    def detail(self, uuid):
        query = sql.select([self.database])
        query = query.where(self.database.c.uuid == uuid)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            restaurant = result['data']
            self.parse(restaurant)
            return jsonify(restaurant)
        else:
            return jsonify({})