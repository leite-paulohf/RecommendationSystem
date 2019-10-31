import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource, abort


class Client(Resource):

    def __init__(self):
        engine = sql.create_engine('sqlite:///database.db', echo=True)
        metadata = sql.MetaData(engine)
        self.connection = engine.connect()
        self.database = sql.Table("clients", metadata, autoload=True)

    def search(self):
        cpf = request.args.get('cpf')
        query = sql.select([self.database.c.cpf])
        query = query.where(self.database.c.cpf == cpf)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(404)

    def register(self):
        client = request.json['client']
        query = sql.insert(self.database)
        query = query.values(full_name=client['full_name'],
                             cpf=client['cpf'],
                             city=client['city'],
                             neighborhood=client['neighborhood'],
                             usages_count=0,
                             password=client['password'])
        try:
            self.connection.execute(query)
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
        query = sql.select([self.database])
        query = query.where(self.database.c.cpf == client['cpf'])
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        return jsonify(result)

    def login(self):
        cpf = request.args.get('cpf')
        password = request.args.get('password')
        query = sql.select([self.database])
        query = query.where(self.database.c.cpf == cpf)
        query = query.where(self.database.c.password == password)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(401)

    def show(self, id):
        query = sql.select([self.database])
        query = query.where(self.database.c.id == id)
        data = self.connection.execute(query)
        result = {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        if bool(result):
            return jsonify(result)
        else:
            abort(401)
