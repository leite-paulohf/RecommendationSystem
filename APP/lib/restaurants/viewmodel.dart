import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class RestaurantViewModel extends Model {
  final RestaurantInterface interface;

  RestaurantViewModel({@required this.interface});

  List<Filter> moments = [];
  List<Filter> cuisines = [];
  List<Filter> chairs = [];
  List<Filter> prices = [];
  List<Filter> ratings = [];

  Filter moment;
  Filter cuisine;
  Filter chair;
  Filter price;
  Filter rating;

  void setMoment(Filter moment) {
    this.moment = moment;
  }

  void setCuisine(Filter cuisine) {
    this.cuisine = cuisine;
  }

  void setChair(Filter chair) {
    this.chair = chair;
  }

  void setPrice(Filter price) {
    this.price = price;
  }

  void setRating(Filter rating) {
    this.rating = rating;
  }

  Future<Tuple2<int, List<Restaurant>>> restaurantsAPI(int city) async {
    return await this.interface.restaurants(city);
  }

  Future<Tuple2<int, List<Restaurant>>> suggestionsAPI(
      int city, int client) async {
    return await this.interface.suggestions(city, client);
  }

  Future<Tuple2<int, List<Restaurant>>> usagesAPI(int city, int client) async {
    return await this.interface.usages(city, client);
  }

  Future<Tuple2<int, List<Restaurant>>> favoritesAPI(
      int city, int client) async {
    return await this.interface.favorites(city, client);
  }

  Future<Tuple2<int, List<Filter>>> momentsAPI() async {
    return await this.interface.moments();
  }

  Future<Tuple2<int, List<Filter>>> cuisinesAPI() async {
    return await this.interface.cuisines();
  }

  Future<Tuple2<int, List<Filter>>> chairsAPI() async {
    return await this.interface.chairs();
  }

  Future<Tuple2<int, List<Filter>>> pricesAPI() async {
    return await this.interface.prices();
  }

  Future<Tuple2<int, List<Filter>>> ratingAPI() async {
    return await this.interface.rating();
  }
}
