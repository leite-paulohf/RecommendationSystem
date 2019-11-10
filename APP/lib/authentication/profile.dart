import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/authentication.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/model/error.dart';

class Profile extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Profile({Key key, @required this.viewModel}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<ScaffoldState>();
  final cache = Preferences();
  final alert = Alert();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: this.cache.userCache(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            this.widget.viewModel.user = snapshot.data;
            if (this.widget.viewModel.user.id == null) return Authentication();
            return Scaffold(
              key: _key,
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(title: Text("Perfil"), centerTitle: true),
              body: Center(child: _body()),
            );
          default:
            return Scaffold(
              key: _key,
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(),
              body: Loader().show(),
            );
        }
      },
    );
  }

  Widget _body() {
    return ScopedModel<AuthenticationViewModel>(
      model: this.widget.viewModel,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            _header(),
            _detail(),
            _citySelector(),
            Padding(padding: EdgeInsets.only(bottom: 20)),
            _logout(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Icon(Icons.account_circle, color: Colors.teal, size: 80),
    );
  }

  Widget _detail() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Text(this.widget.viewModel.user.name.toUpperCase() ?? "",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              )),
          Text(this.widget.viewModel.user.cpf.toString() ?? "",
              style: TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _citySelector() {
    return FutureBuilder<List<Filter>>(
      future: _regions(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            this.widget.viewModel.cities = snapshot.data;
            var cityId = this.widget.viewModel.user.cityId ?? 10;
            var index = _cityIds().indexOf(cityId);
            var city = this.widget.viewModel.cities[index];
            var title = city?.name?.toUpperCase() ?? "SELECIONE SUA CIDADE";
            return Button(label: title, submitted: _showPicker);
          default:
            return Button(label: "CARREGANDO...", submitted: () {});
        }
      },
    );
  }

  List<String> _cityNames() {
    var cities = this.widget.viewModel.cities.map((city) {
      return city.name;
    }).toList();
    return cities;
  }

  List<int> _cityIds() {
    var cities = this.widget.viewModel.cities.map((city) {
      return city.id;
    }).toList();
    return cities;
  }

  void _showPicker() {
    var cityId = this.widget.viewModel.user.cityId ?? 10;
    var index = _cityIds().indexOf(cityId);

    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _cityNames()),
        selecteds: [index],
        height: 200,
        itemExtent: 40,
        changeToFirst: true,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
        cancelText: "CANCELAR",
        cancelTextStyle: TextStyle(color: Colors.teal),
        confirmText: "CONFIRMAR",
        confirmTextStyle: TextStyle(color: Colors.teal),
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(16.0),
        onConfirm: (Picker picker, List value) {
          var index = picker.selecteds.first;
          var city = this.widget.viewModel.cities[index];
          this.widget.viewModel.user.cityId = city.id;
          _update();
        });

    picker.show(_key.currentState);
  }

  Widget _logout() {
    return Button(
      label: "SAIR",
      submitted: () {
        setState(() {
          this.cache.setUser(User());
        });
      },
    );
  }

  Future<List<Filter>> _regions() async {
    var cities = await this.cache.filtersCache("cities");
    if (cities.isNotEmpty) return cities;
    var result = await this.widget.viewModel.regions();
    var code = result.item1;
    switch (code) {
      case 200:
        this.cache.setFilters(result.item2, "cities");
        return result.item2;
        break;
      default:
        this.alert.error(context, Error.from(code).message);
        return [];
    }
  }

  void _update() async {
    var result = await this.widget.viewModel.update();
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          this.cache.setUser(result.item2);
          this.cache.setRestaurants([], result.item2.id, "restaurants");
        });
        break;
      default:
        this.alert.error(context, Error.from(code).message);
    }
  }
}
