import sqlalchemy as sql
from flask import jsonify
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

class City(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('city', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

class Neighbourhood(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('neighbourhood', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

class Cuisine(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('cuisine', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

class Category(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('category', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

class Moment(Resource):
    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('moment', metadata,
                                  sql.Column('id', sql.String, primary_key=True),
                                  sql.Column('name', sql.String))
        metadata.create_all(engine)

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

    def get(self):
        query = sql.select([self.database])
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return jsonify(result)

    def get(self, uuid):
        query = sql.select([self.database])
        query = query.where(self.database.c.uuid == uuid)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return jsonify(result)
