import 'Restaurant.dart';

class Restaurants {
	final List<Restaurant> restaurants;

	Restaurants({this.restaurants});

	factory Restaurants.fromModel(Map<String, dynamic> model) {
		return Restaurants(restaurants: model['data']);
	}

	Map<String, dynamic> toJson() => {'data': this.restaurants};
}