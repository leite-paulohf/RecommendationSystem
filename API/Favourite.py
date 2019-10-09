import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource
import json

class Favourite(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('favourite', metadata,
                                  sql.Column('uuid', sql.String, primary_key=True),
                                  sql.Column('client_uuid', sql.String))
        metadata.create_all(engine)

    def favourite(self):
        favourite = request.json['favourite']
        query = sql.insert(self.database)
        query = query.values(uuid=favourite['uuid'], client_uuid=favourite['client_uuid'])
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database])
        query = query.where(self.database.c.client_uuid == favourite['client_uuid'])
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return jsonify(result)

    def favourites(self):
        client_uuid = request.args.get('client_uuid')
        query = sql.select([self.database.c.uuid])
        query = query.where(self.database.c.client_uuid == client_uuid)
        data = self.connection.execute(query).fetchall()
        array = [dict(value) for value in data]
        return json.dumps({'data': array})