import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/service/favourites.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class FavouritesViewModel extends Model {
  final FavouritesInterface interface;

  FavouritesViewModel({@required this.interface});

  String cuuid;
  String ruuid;

  Future<Tuple2<int, List<Restaurant>>> addFavourite() async {
    return await this.interface.addFavourite(this.cuuid, this.ruuid);
  }

  Future<Tuple2<int, List<Restaurant>>> removeFavourite() async {
    return await this.interface.removeFavourite(this.cuuid, this.ruuid);
  }

  Future<Tuple2<int, List<Restaurant>>> getAllFavourites() async {
    return await this.interface.getAllFavourites(this.cuuid, this.ruuid);
  }
}
