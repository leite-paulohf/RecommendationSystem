import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/user.dart';

class Restaurants extends StatefulWidget {
  Restaurants({Key key}) : super(key: key);

  @override
  RestaurantsState createState() => RestaurantsState();
}

class RestaurantsState extends State<Restaurants> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = RestaurantViewModel(interface: RestaurantService());
  final aViewModel = AuthenticationViewModel(interface: UserService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      body: _body2(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body2() {
    return FutureBuilder<List<Restaurant>>(
      future: _search(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var restaurants = snapshot.data ?? [];
            return Text(restaurants.first.name);
          default:
            return Loader().show();
        }
      },
    );
  }

  Widget _body() {
    return FutureBuilder<List<Restaurant>>(
      future: _search(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ScopedModel<RestaurantViewModel>(
                model: this.viewModel,
                child: TableView(
                  restaurants: snapshot.data ?? [],
                  booking: _booking,
                  favourite: _favourite,
                ));
          default:
            return Loader().show();
        }
      },
    );
  }

  Widget _card() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const ListTile(
            leading: Icon(Icons.album),
            title: Text('The Enchanted Nightingale'),
            subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
          ),
          ButtonTheme.bar(
            child: ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('BUY TICKETS'),
                  onPressed: () {
                    /* ... */
                  },
                ),
                FlatButton(
                  child: const Text('LISTEN'),
                  onPressed: () {
                    /* ... */
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _citySelector() {
    return FutureBuilder<List<Filter>>(
      future: this.aViewModel.getCities(context),
      builder: (context, snapshot) {
        var city = this.aViewModel.city;
        var title = city?.name?.toUpperCase() ?? "SELECT CITY";
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var cities = snapshot.data;
            cities.sort((e1, e2) {
              return e1.name.toLowerCase().compareTo(e2.name.toLowerCase());
            });
            this.aViewModel.cities = cities;
            return Button(label: title, submitted: _showPicker);
          default:
            return Button(label: title, submitted: () {});
        }
      },
    );
  }

  void _showPicker() {
    var cities = this.aViewModel.cities.map((city) {
      return city.name;
    }).toList();
    var city = this.aViewModel.city?.name ?? "";
    var index = cities.indexOf(city);
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: cities),
        selecteds: [index],
        height: 200,
        itemExtent: 40,
        changeToFirst: true,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
        cancelText: "CANCEL",
        cancelTextStyle: TextStyle(color: Colors.teal),
        confirmText: "CONFIRM",
        confirmTextStyle: TextStyle(color: Colors.teal),
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(16.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            var index = picker.selecteds.first;
            var city = this.aViewModel.cities[index];
            this.aViewModel.city = city;
            this.aViewModel.user.cityId = city.id;
          });
        });
    picker.show(_key.currentState);
  }

  Future<List<Restaurant>> _search() async {
    var result = await this.viewModel.search(6);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  void _booking() {}

  void _favourite() {}
}
