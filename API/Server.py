from flask import Flask
from flask_restful import Api
from Client import Client
from Favourite import Favourite
from Restaurants import Restaurants

app = Flask(__name__)

#   CLIENT

@app.route('/', methods=['GET'])
def root():
    return "online"

#   CLIENT

@app.route('/client/search', methods=['GET'])
def search():
    return Client().search()

@app.route('/client/register', methods=['POST'])
def register():
    return Client().register()

@app.route('/client/login', methods=['GET'])
def login():
    return Client().login()

@app.route('/client/show/<uuid>', methods=['GET'])
def show(uuid):
    return Client().show(uuid)


#   FAVOURITE

@app.route('/favourite', methods=['POST'])
def favourite():
    return Favourite().favourite()

@app.route('/favourites', methods=['GET'])
def favourites():
    return Favourite().favourites()

#   RESTAURANTS

@app.route('/restaurants', methods=['GET'])
def getAll():
    return Restaurants().getAll()

@app.route('/restaurant/<uuid>', methods=['GET'])
def detail(uuid):
    return Restaurants().detail(uuid)

#   RUN

if __name__ == '__main__':
    app.env = "development"
    api = Api(app)
    app.run(debug=True)