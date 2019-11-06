import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/service/favorites.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class FavoritesViewModel extends Model {
  final FavoritesInterface interface;

  FavoritesViewModel({@required this.interface});

  Restaurant restaurant = Restaurant();
  List<Restaurant> restaurants = [];

  Future<Tuple2<int, List<Restaurant>>> addFavorite(
      int clientId, int restaurantId) async {
    return await this.interface.addFavorite(clientId, restaurantId);
  }

  Future<Tuple2<int, List<Restaurant>>> removeFavorite(
      int clientId, int restaurantId) async {
    return await this.interface.removeFavorite(clientId, restaurantId);
  }

  Future<Tuple2<int, List<Restaurant>>> favorites(int clientId) async {
    return await this.interface.favorites(clientId);
  }
}
