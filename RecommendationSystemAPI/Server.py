from flask import Flask
from flask_restful import Api
from Usage import Usage
from Usages import Usages
from Restaurants import Restaurants

class Server:

    def __init__(self):
        self.app = Flask(__name__)
        self.api = Api(self.app)

    def routes(self):
        self.api.add_resource(Usage, '/usage')
        self.api.add_resource(Usages, '/usage/<user_id>')
        self.api.add_resource(Restaurants, '/restaurants')

if __name__ == '__main__':
    server = Server()
    server.routes()
    server.app.run()
