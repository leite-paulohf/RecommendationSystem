import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class RestaurantViewModel extends Model {
  final RestaurantInterface interface;

  RestaurantViewModel({@required this.interface});

  Future<Tuple2<int, List<Restaurant>>> restaurants(int city) async {
    return await this.interface.restaurants(city);
  }

  Future<Tuple2<int, List<Restaurant>>> general(int city, int client) async {
    return await this.interface.general(city, client);
  }

  Future<Tuple2<int, List<Restaurant>>> usages(int city, int client) async {
    return await this.interface.usages(city, client);
  }

  Future<Tuple2<int, List<Restaurant>>> favorites(int city, int client) async {
    return await this.interface.favorites(city, client);
  }
}
