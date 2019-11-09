import hashlib
import sqlalchemy as sql
from sqlalchemy import exc
from flask import request, jsonify
from flask_restful import Resource, abort
from query.enum import Query


class Cities(Resource):

    def __init__(self):
        self.engine = sql.create_engine('sqlite:///database.db', echo=True)
        self.connection = self.engine.connect()

    def list(self):
        query = self.query(Query.cities.value)
        data = self.request(query)
        if bool(data):
            data = sorted(data, key=lambda k: k['name'])
            return jsonify({'data': data})
        else:
            abort(401)

    def query(self, file):
        fd = open(file, 'r')
        query = fd.read()
        fd.close()
        return query

    def request(self, query):
        try:
            data = self.connection.execute(query)
            if data.cursor is not None:
                return [dict(zip(tuple(data.keys()), i)) for i in data.cursor]
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
