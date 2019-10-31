import sqlalchemy as sql
from flask import jsonify, request
from flask_restful import Resource


class City(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table("cities", metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Neighborhood(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table("neighborhoods", metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Kind(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table("kind", metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Cuisine(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('cuisines', metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Category(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('categories', metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Moment(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('moments', metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Offer(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('offers', metadata, autoload=True)

    def get(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return result['data']


class Restaurants(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('restaurants', metadata, autoload=True)

    def parse(self, restaurant):
        city_id = restaurant.pop('city_id')
        city = City().get(city_id)
        restaurant['city'] = city

        neighborhood_id = restaurant.pop('neighborhood_id')
        neighborhood = Neighborhood().get(neighborhood_id)
        restaurant['neighborhood'] = neighborhood

        kind_id = restaurant.pop('kind_id')
        kind = Kind().get(kind_id)
        restaurant['kind'] = kind

        cuisine_id = restaurant.pop('cuisine_id')
        cuisine = Cuisine().get(cuisine_id)
        restaurant['cuisine'] = cuisine

        category_id = restaurant.pop('category_id')
        category = Category().get(category_id)
        restaurant['category'] = category

        moment_id = restaurant.pop('moment_id')
        moment = Moment().get(moment_id)
        restaurant['moment'] = moment

        offer_id = restaurant.pop('offer_id')
        offer = Offer().get(offer_id)
        restaurant['offer'] = offer

        return restaurant

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
        city_id = request.args.get('city_id')
        page = int(request.args.get('page'))
        per_page = 25
        offset = page * per_page
        query = sql.select([self.database])
        query = query.where(self.database.c.city_id == city_id)
        query = query.limit(per_page).offset(offset)
        data = self.connection.execute(query)
        result = {
            'data': {
                'pagination': self.pagination(per_page, page),
                'restaurants': [dict(zip(tuple(data.keys()), i)) for i in data.cursor]
            }
        }
        if bool(result):
            for restaurant in result['data']['restaurants']:
                self.parse(restaurant)
            return jsonify(result)
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
