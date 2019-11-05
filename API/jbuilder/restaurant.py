from flask import jsonify


class RestaurantBuilder():

    def restaurants(self, restaurants):
        for restaurant in restaurants:
            self.builder(restaurant)
        return jsonify(restaurants)

    def restaurant(self, restaurant):
        self.builder(restaurant)
        return jsonify(restaurant)

    def builder(self, restaurant):
        restaurant["city"] = {
            "id": restaurant.pop("city_id"),
            "name": restaurant.pop("city_name")
        }
        restaurant["neighborhood"] = {
            "id": restaurant.pop("neighborhood_id"),
            "name": restaurant.pop("neighborhood_name")
        }
        restaurant["kind"] = {
            "id": restaurant.pop("kind_id"),
            "name": restaurant.pop("kind_name")
        }
        restaurant["cuisine"] = {
            "id": restaurant.pop("cuisine_id"),
            "name": restaurant.pop("cuisine_name")
        }
        restaurant["category"] = {
            "id": restaurant.pop("category_id"),
            "name": restaurant.pop("category_name")
        }
        restaurant["moment"] = {
            "id": restaurant.pop("moment_id"),
            "name": restaurant.pop("moment_name")
        }
        restaurant["offer"] = {
            "id": restaurant.pop("offer_id"),
            "discount": restaurant.pop("discount"),
            "benefits": restaurant.pop("benefits"),
            "restrictions": restaurant.pop("restrictions")
        }
