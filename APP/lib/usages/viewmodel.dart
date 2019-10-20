import 'package:tcc_app/model/restaurant.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tcc_app/service/usages.dart';
import 'package:tuple/tuple.dart';

class UsagesViewModel extends Model {
  final UsagesInterface interface;

  UsagesViewModel({@required this.interface});

  Future<Tuple2<int, List<Restaurant>>> search(int city) async {
    return await this.interface.search(city);
  }
}
