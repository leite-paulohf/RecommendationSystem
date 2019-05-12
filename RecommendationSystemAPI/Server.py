from flask import Flask
from flask_restful import Api
from Usage import Usage
from Usages import Usages
from Restaurants import Restaurants
from Recommendation import Recommendation

class Server:

    def __init__(self):
        self.app = Flask(__name__)
        self.app.env = "development"
        self.api = Api(self.app)
        self.routes()

    def routes(self):
        self.api.add_resource(Usage, '/usage')
        self.api.add_resource(Usages, '/usage/<user_id>')
        self.api.add_resource(Restaurants, '/restaurants')
        self.api.add_resource(Recommendation, '/recommendation/<city_id>/<user_id>')

if __name__ == '__main__':
    server = Server()
    server.app.run()
