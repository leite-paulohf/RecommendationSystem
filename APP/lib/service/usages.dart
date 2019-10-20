import 'dart:async';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class UsagesInterface {
	Future<Tuple2<int, List<Restaurant>>> search(int city);
}

class UsagesService implements UsagesInterface {
	static final UsagesService _internal = UsagesService.internal();

	factory UsagesService() => _internal;

	UsagesService.internal();

	@override
	Future<Tuple2<int, List<Restaurant>>> search(int city) async {
		Map<String, String> data = {'city_id': city.toString()};
		var response = await Service().get('restaurants', data);
		return Service().parseRestaurants(response);
	}

}
