from flask import Flask
from flask_restful import Api
from Client import Client
from Favourite import Favourite
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

@app.route('/client/show/<uuid>', methods=['GET'])
def showClient(uuid):
    return Client().show(uuid)

#   FAVOURITE

@app.route('/favourites', methods=['POST'])
def addFavourites():
    return Favourite().add()

@app.route('/favourites', methods=['DELETE'])
def removeFavourites():
    return Favourite().remove()

@app.route('/favourites', methods=['GET'])
def getAllFavourites():
    return Favourite().getAll()

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