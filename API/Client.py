import uuid
import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource, abort


class Client(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo = True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table('client', metadata,
                                  sql.Column('uuid', sql.String, primary_key=True),
                                  sql.Column('name', sql.String),
                                  sql.Column('document', sql.String, unique=True),
                                  sql.Column('password', sql.String))
        metadata.create_all(engine)

    def search(self):
        document = request.args.get('document')
        query = sql.select([self.database.c.document])
        query = query.where(self.database.c.document == document)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(404)

    def register(self):
        client = request.json['client']
        query = sql.insert(self.database)
        query = query.values(
            uuid=str(uuid.uuid4()),
            name=client['name'],
            document=client['document'],
            password=client['password'])
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database])
        query = query.where(self.database.c.document == client['document'])
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return jsonify(result)

    def login(self):
        document = request.args.get('document')
        password = request.args.get('password')
        query = sql.select([self.database])
        query = query.where(self.database.c.document == document)
        query = query.where(self.database.c.password == password)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(401)

    def show(self, uuid):
        query = sql.select([self.database])
        query = query.where(self.database.c.uuid == uuid)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(401)
