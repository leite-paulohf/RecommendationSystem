import 'package:tcc_app/model/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tcc_app/service/usages.dart';
import 'package:tuple/tuple.dart';

class UsagesViewModel extends Model {
  final UsagesInterface interface;

  UsagesViewModel({@required this.interface});

  Future<Tuple2<int, List<Restaurant>>> usages(int clientId) async {
    return await this.interface.usages(clientId);
  }

  Future<Tuple2<int, List<Restaurant>>> usage(
      int chairs, int clientId, int restaurantId) async {
    return await this.interface.usage(chairs, clientId, restaurantId);
  }
}
