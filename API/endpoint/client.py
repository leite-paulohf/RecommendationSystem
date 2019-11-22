import datetime
import hashlib
import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource, abort
from query.enum import Query


class Client(Resource):

    def __init__(self):
        self.engine = sql.create_engine('sqlite:///database.db', echo=True)
        self.connection = self.engine.connect()

    def search(self):
        cpf = request.args.get('cpf')
        query = self.query(Query.search_client.value)
        params = {'cpf': cpf}
        data = self.request(query, params)
        if bool(data):
            return jsonify(data)
        else:
            abort(404)

    def register(self):
        client = request.json['client']
        password = hashlib.md5(client['password'].encode())
        query = self.query(Query.create_client.value)
        params = {"created_at": datetime.datetime.now(),
                  "name": client['name'],
                  "cpf": client['cpf'],
                  "city_id": client['city_id'],
                  "password": password.hexdigest()}
        self.request(query, params)
        query = self.query(Query.client.value)
        params = {'cpf': client['cpf'], 'password': password.hexdigest()}
        data = self.request(query, params)
        if bool(data):
            return jsonify(data)
        else:
            abort(401)

    def update(self):
        client = request.json['client']
        query = self.query(Query.update_client.value)
        params = {"name": client['name'],
                  "cpf": client['cpf'],
                  "city_id": client['city_id'],
                  "password": client['password']}
        self.request(query, params)
        query = self.query(Query.client.value)
        params = {'cpf': client['cpf'], 'password': client['password']}
        data = self.request(query, params)
        if bool(data):
            return jsonify(data)
        else:
            abort(401)

    def login(self):
        cpf = request.args.get('cpf')
        password = hashlib.md5(request.args.get('password').encode())
        query = self.query(Query.client.value)
        params = {'cpf': cpf, 'password': password.hexdigest()}
        data = self.request(query, params)
        if bool(data):
            return jsonify(data)
        else:
            abort(401)

    def query(self, file):
        fd = open(file, 'r')
        query = fd.read()
        fd.close()
        return query

    def request(self, query, params=None):
        try:
            data = self.connection.execute(query, params)
            if data.cursor is not None:
                return {'data': dict(zip(tuple(data.keys()), i)) for i in data.cursor}
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
