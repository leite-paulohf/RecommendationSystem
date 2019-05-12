from sqlalchemy import create_engine
from flask_restful import Resource
from flask import jsonify
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.model_selection import KFold
import matplotlib.pyplot as plt

class Helper:

    def __init__(self):
        self.engine = create_engine('sqlite:///database.db')

    def usages(self, user_id, city_id):
        query = """
                SELECT
                time_id, discount, cuisine_id, 
                price_range, rating, moments_id, categories_id 
                FROM usages 
                WHERE 
                user_id = {} AND
                city_id = {}
                """.format(user_id, city_id)
        return pd.read_sql_query(query, self.engine)

    def dataset(self, user_id, city_id):
        query = """
                SELECT
                time_id, discount, cuisine_id, 
                price_range, rating, moments_id, categories_id
                FROM usages 
                WHERE 
                user_id != {} AND
                city_id = {}
                """.format(user_id, city_id)
        return pd.read_sql_query(query, self.engine)

    def kmeans_method(self, user_id, city_id, clusters):
        usages = self.usages(user_id, city_id).values
        dataset = self.dataset(user_id, city_id).values
        kmeans = KMeans(n_clusters = clusters, init = 'random')
        kmeans.fit(dataset)

        dataset = np.array(dataset)
        usages = np.array(usages)
        cluster = np.array(kmeans.cluster_centers_)

        axis = ["time", "discount", "cuisine", "price", "rating", "moments", "categories"]
        colors = ['y', 'b', 'c', 'm']

        for x in range(axis.__len__()):
            for y in range(axis.__len__()):
                if (x != y and y > x) and (x == 3 or y == 3):
                    plt.plot()
                    plt.title('Clusters')
                    plt.xlabel(axis[x])
                    plt.ylabel(axis[y])

                    clusterX = cluster[:, x]
                    clusterY = cluster[:, y]

                    datasetX = dataset[:, x]
                    datasetY = dataset[:, y]

                    usagesX = usages[:, x]
                    usagesY = usages[:, y]

                    for i, l in enumerate(kmeans.cluster_centers_):
                        plt.plot(clusterX[i],
                                 clusterY[i],
                                 color=colors[i],
                                 marker="x",
                                 markersize=10,
                                 ls='None',
                                 label=str(i+1))

                    for i, l in enumerate(kmeans.labels_):
                        plt.plot(datasetX[i],
                                 datasetY[i],
                                 color=colors[l],
                                 marker=".",
                                 ls='None')

                    for i in range(usagesX.__len__()):
                        plt.plot(usagesX[i],
                                 usagesY[i],
                                 color="r",
                                 marker=".",
                                 markersize=10,
                                 ls='None')

                    plt.legend(bbox_to_anchor=(1, 1), loc=2, borderaxespad=0)
                    path = "centroids/{}{}_{}_x_{}.png".format(x, y, axis[x], axis[y])
                    plt.savefig(path)
                    plt.close()

    def kmeans(self, user_id, city_id, clusters):
        dataset = self.dataset(user_id, city_id).values
        kmeans = KMeans(n_clusters = clusters, init = 'random')
        kmeans.fit(dataset)
        centers = np.array(kmeans.cluster_centers_)
        values = np.array(dataset)
        axis = ["time", "discount", "cuisine", "price", "rating", "moments", "categories"]
        colors = ['y', 'b', 'c', 'm']
        for x in range(axis.__len__()):
            for y in range(axis.__len__()):
                if (x != y and y > x) and (x == 3 or y == 3):
                    plt.plot()
                    plt.title('Clusters')
                    plt.xlabel(axis[x])
                    plt.ylabel(axis[y])
                    centersX = centers[:, x]
                    centersY = centers[:, y]
                    for i, l in enumerate(kmeans.cluster_centers_):
                        plt.plot(centersX[i], centersY[i], markersize=10, color=colors[i], marker="x", ls='None', label=str(i+1))
                    valuesX = values[:, x]
                    valuesY = values[:, y]
                    for i, l in enumerate(kmeans.labels_):
                        plt.plot(valuesX[i], valuesY[i], color=colors[l], marker=".", ls='None')
                    plt.legend(bbox_to_anchor=(1, 1), loc=2, borderaxespad=0)
                    path = "centroids/{}{}_{}_x_{}.png".format(x, y, axis[x], axis[y])
                    plt.savefig(path)
                    plt.close()

    def elbow(self, user_id, city_id, size):
        dataset = self.dataset(user_id, city_id).values
        sum_of_squares = []
        for clusters in size:
            kmeans = KMeans(n_clusters=clusters, init='random')
            kmeans.fit(dataset)
            print(clusters, kmeans.inertia_)
            sum_of_squares.append(kmeans.inertia_)
        plt.plot(size, sum_of_squares)
        plt.title('The Elbow Method')
        plt.xlabel('Clusters - Cuisines')
        plt.ylabel('Variation')
        plt.show()
        plt.savefig('elbow.png')

class Recommendation(Resource):

    def get(self, user_id, city_id):
        try:
            helper = Helper()
            helper.kmeans_method(user_id, city_id, 4)
            result = {'data': "success"}
            return jsonify(result)
        except Exception as e:
            result = {'error': str(e)}
            return jsonify(result)