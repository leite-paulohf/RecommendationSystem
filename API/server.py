from flask import Flask
from flask_restful import Api
from endpoint.cities import Cities
from endpoint.moments import Moments
from endpoint.chairs import Chairs
from endpoint.rating import Rating
from endpoint.prices import Prices
from endpoint.cuisines import Cuisines
from endpoint.client import Client
from endpoint.favorite import Favorite
from endpoint.restaurants import Restaurants
from endpoint.usages import Usages
from endpoint.recommendation import Recommendation
from endpoint.preferences import Preference

app = Flask(__name__)


#   DEFAULT

@app.route('/', methods=['GET'])
def root():
    return "Server Online"


#   CITY

@app.route('/cities', methods=['GET'])
def cities():
    return Cities().list()


#	MOMENTS

@app.route('/moments', methods=['GET'])
def moments():
    return Moments().list()


#	CHAIRS

@app.route('/chairs', methods=['GET'])
def chairs():
    return Chairs().list()


#	RATING

@app.route('/rating', methods=['GET'])
def rating():
    return Rating().list()


#	PRICES

@app.route('/prices', methods=['GET'])
def prices():
    return Prices().list()


#	CUISINES

@app.route('/cuisines', methods=['GET'])
def cuisines():
    return Cuisines().list()


#   CLIENT

@app.route('/client/search', methods=['GET'])
def search():
    return Client().search()


@app.route('/client/register', methods=['POST'])
def register():
    return Client().register()


@app.route('/client/update', methods=['PUT'])
def update():
    return Client().update()


@app.route('/client/login', methods=['GET'])
def login():
    return Client().login()


@app.route('/client/show/<id>', methods=['GET'])
def client(id):
    return Client().show(id)


#   FAVORITES

@app.route('/favorites', methods=['POST'])
def favorite():
    return Favorite().add()


@app.route('/favorites', methods=['DELETE'])
def unfavorite():
    return Favorite().remove()


@app.route('/favorites', methods=['GET'])
def favourites():
    return Favorite().list()


#   RESTAURANTS

@app.route('/restaurants', methods=['GET'])
def restaurants():
    return Restaurants().list()


@app.route('/restaurant/<restaurant_id>', methods=['GET'])
def restaurant(restaurant_id):
    return Restaurants().show(restaurant_id)


#   PREFERENCES

@app.route('/restaurants/preferences', methods=['POST'])
def preferences():
    return Preference().add()


#   USAGES

@app.route('/usage', methods=['POST'])
def usage():
    return Usages().create()


@app.route('/usages', methods=['GET'])
def usages():
    return Usages().list()


#   RECOMMENDATIONS

@app.route('/restaurants/onboarding', methods=['GET'])
def onboarding():
    return Recommendation().by_onboarding()


@app.route('/restaurants/recommendations', methods=['GET'])
def recommendations():
    return Recommendation().by_preferences()


@app.route('/usages/recommendations', methods=['GET'])
def usages_recommendations():
    return Recommendation().by_usages()


@app.route('/favorites/recommendations', methods=['GET'])
def favorites_recommendations():
    return Recommendation().by_favorites()


#   RUN

if __name__ == '__main__':
    app.env = "development"
    api = Api(app)
    app.run(debug=True)
