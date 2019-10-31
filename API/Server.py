from flask import Flask
from flask_restful import Api
from Client import Client
from Favorite import Favorite
from Restaurants import Restaurants

app = Flask(__name__)


#   DEFAULT

@app.route('/', methods=['GET'])
def root():
    return "Server Online"


#   CLIENT

@app.route('/client/search', methods=['GET'])
def searchClient():
    return Client().search()


@app.route('/client/register', methods=['POST'])
def registerClient():
    return Client().register()


@app.route('/client/login', methods=['GET'])
def loginClient():
    return Client().login()


@app.route('/client/show/<id>', methods=['GET'])
def showClient(id):
    return Client().show(id)


#   FAVORITES

@app.route('/favorites', methods=['POST'])
def addFavourites():
    return Favorite().add()


@app.route('/favorites', methods=['DELETE'])
def removeFavourites():
    return Favorite().remove()


@app.route('/favorites', methods=['GET'])
def getAllFavourites():
    return Favorite().getAll()


#   RESTAURANTS

@app.route('/restaurants', methods=['GET'])
def getAllRestaurants():
    return Restaurants().getAll()


@app.route('/restaurant/<uuid>', methods=['GET'])
def detailRestaurant(uuid):
    return Restaurants().detail(uuid)


#   RUN

if __name__ == '__main__':
    app.env = "development"
    api = Api(app)
    app.run(debug=True)
