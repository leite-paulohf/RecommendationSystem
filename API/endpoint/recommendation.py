import collections as coll
import numpy as np
import pandas as pd
import sqlalchemy as sql
from flask import request, jsonify
from flask_restful import Resource
from sklearn import preprocessing
from sklearn.cluster import KMeans
from sqlalchemy import exc
from jbuilder.restaurant import RestaurantBuilder
from query.enum import Query, PrivateQuery


class Recommendation(Resource):

    def __init__(self):
        self.builder = RestaurantBuilder()
        self.engine = sql.create_engine('sqlite:///database.db', echo=True)
        self.connection = self.engine.connect()

    def by_onboarding(self):
        onboarding = self.onboarding(request)
        if onboarding.empty:
            return jsonify({'data': []})
        restaurants = self.restaurants(request)
        if restaurants.empty:
            return jsonify({'data': []})
        recommended = self.k_means_round(onboarding, restaurants)
        recommendations = self.recommendations(tuple(recommended))
        return recommendations

    def by_preferences(self):
        preferences = self.preferences(request)
        if preferences.empty:
            return jsonify({'data': []})
        restaurants = self.restaurants(request)
        if restaurants.empty:
            return jsonify({'data': []})
        recommended = self.k_means_round(preferences, restaurants)
        recommendations = self.recommendations(tuple(recommended))
        return recommendations

    def by_usages(self):
        usages = self.usages(request)
        if usages.empty:
            return jsonify({'data': []})
        restaurants = self.restaurants(request)
        if restaurants.empty:
            return jsonify({'data': []})
        recommended = self.k_means_round(usages, restaurants)
        recommendations = self.recommendations(tuple(recommended))
        return recommendations

    def by_favorites(self):
        favorites = self.favorites(request)
        if favorites.empty:
            return jsonify({'data': []})
        restaurants = self.restaurants(request)
        if restaurants.empty:
            return jsonify({'data': []})
        recommended = self.k_means_round(favorites, restaurants)
        recommendations = self.recommendations(tuple(recommended))
        return recommendations

    def k_means_round(self, personal, restaurants):
        base = self.normalize(self.features(personal))
        training = self.normalize(self.features(restaurants))
        n_clusters = self.elbow(training)
        try:
            recommended = self.k_means(base, training, n_clusters)
            restaurants = restaurants.loc[recommended].reset_index(drop=True)
            if len(restaurants) <= 25:
                return restaurants['id']
            if n_clusters <= 1:
                return []
            return self.k_means_round(personal, restaurants)
        except:
            return restaurants['id']

    def k_means(self, base, training, n_clusters):
        k_means = KMeans(n_clusters=n_clusters, init='k-means++')
        k_means = k_means.fit(training)
        predict = k_means.predict(base)
        n_cluster = coll.Counter(predict).most_common(1).pop()
        return np.where(k_means.labels_ == n_cluster[0])[0]

    def features(self, data_frame):
        return data_frame[data_frame.columns.difference(['id', 'offer_id'])]

    def normalize(self, data_frame):
        scale = preprocessing.MinMaxScaler()
        normalized = scale.fit_transform(data_frame.values)
        normalized_data_frame = pd.DataFrame(normalized)
        normalized_data_frame.columns = data_frame.columns
        return normalized_data_frame

    def elbow(self, features):
        size = list(range(1, 11))
        variations = []
        for clusters in size:
            k_means = KMeans(n_clusters=clusters, init='random')
            k_means.fit(features)
            variations.append(k_means.inertia_)
        average = np.average(variations)
        variations = list(filter(lambda variation: variation > average, variations))
        return len(variations)

    def onboarding(self, request):
        data = [{'id': 0,
                 'accept_holidays': 0,
                 'average_cost': request.args.get('price'),
                 'average_rating': request.args.get('rating'),
                 'benefits': 0,
                 'category_id': 0,
                 'chairs': request.args.get('chairs'),
                 'cuisine_id': request.args.get('cuisine'),
                 'discount': 0,
                 'has_wifi': 0,
                 'kind_id': 0,
                 'latitude': 0,
                 'longitude': 0,
                 'moment_id': request.args.get('moment'),
                 'neighborhood_id': 0,
                 'restrictions': 0,
                 'offer_id': 0}]
        return pd.DataFrame(data)

    def preferences(self, request):
        query = self.query(PrivateQuery.preferences.value)
        params = {"client_id": request.args.get('client_id')}
        data = self.request(query, params)
        return pd.DataFrame(data)

    def usages(self, request):
        query = self.query(PrivateQuery.usages.value)
        params = {"client_id": request.args.get('client_id')}
        data = self.request(query, params)
        return pd.DataFrame(data)

    def favorites(self, request):
        query = self.query(PrivateQuery.favorites.value)
        params = {"client_id": request.args.get('client_id')}
        data = self.request(query, params)
        return pd.DataFrame(data)

    def restaurants(self, request):
        query = self.query(PrivateQuery.restaurants.value)
        params = {"city_id": request.args.get('city_id')}
        data = self.request(query, params)
        return pd.DataFrame(data)

    def recommendations(self, ids):
        query = self.query(Query.recommendations.value).replace(':ids', str(ids))
        data = self.request(query, {})
        return self.builder.restaurants(data)

    def query(self, file):
        fd = open(file, 'r')
        query = fd.read()
        fd.close()
        return query

    def request(self, query, params=None):
        try:
            data = self.connection.execute(query, params)
            if data.cursor is not None:
                return [dict(zip(tuple(data.keys()), i)) for i in data.cursor]
        except exc.SQLAlchemyError as error:
            return {'error': {'code': error.code, 'message': error.orig.args[0]}}
