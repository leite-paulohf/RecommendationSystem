import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tuple/tuple.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = RestaurantViewModel(interface: RestaurantService());
  final preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("Bem Vindo!")),
      body: _body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body() {
    return ListView(
      padding: EdgeInsets.only(left: 32, right: 32),
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20)),
        _title("Olá, seja bem vindo!"),
        _title("Para oferecer a melhor experiência,"),
        _title("precisamos te conhecer melhor"),
        _header("Quais são as suas culinárias favoritas?"),
        _selector(
          "CULINÁRIAS",
          _filters(this.viewModel.cuisinesAPI(), "cuisines"),
          this.viewModel.cuisines,
          this.viewModel.selectedCuisines,
        ),
        _header("Gostaria de conhecer restaurantes com quais avaliações?"),
        _selector(
          "AVALIAÇÕES",
          _filters(this.viewModel.ratingAPI(), "rating"),
          this.viewModel.rating,
          this.viewModel.selectedRating,
        ),
        _header("Quais faixas de preço te agrada?"),
        _selector(
          "PREÇO MÉDIO",
          _filters(this.viewModel.pricesAPI(), "prices"),
          this.viewModel.prices,
          this.viewModel.selectedPrices,
        ),
        _header("Constuma sair para comer com quantas pessoas?"),
        _selector(
          "PESSOAS NA MESA",
          _filters(this.viewModel.chairsAPI(), "chairs"),
          this.viewModel.chairs,
          this.viewModel.selectedChairs,
        ),
        _header("Quais ocasiões mais te levam para comer fora de casa?"),
        _selector(
          "MOMENTOS",
          _filters(this.viewModel.momentsAPI(), "moments"),
          this.viewModel.moments,
          this.viewModel.selectedMoments,
        ),
        _sendButton()
      ],
    );
  }

  Widget _title(String text) {
    return Container(
      child: Text(text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _header(String text) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Text(text,
          style: TextStyle(
            fontSize: 17,
          )),
    );
  }

  Widget _selector(
    String title,
    Future future,
    List<Filter> filters,
    List<Filter> selectedFilters,
  ) {
    return FutureBuilder<List<Filter>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            filters = snapshot.data;
            return Button(
                label: title,
                submitted: () {
                  _showPicker(filters, selectedFilters);
                });
          default:
            return Button(label: "CARREGANDO...", submitted: () {});
        }
      },
    );
  }

  List<String> _filterNames(List<Filter> filters) {
    var names = filters.map((filter) {
      return filter.name;
    }).toList();
    return names;
  }

  List<int> _filterIds(List<Filter> filters) {
    var ids = filters.map((filter) {
      return filter.id;
    }).toList();
    return ids;
  }

  void _showPicker(List<Filter> filters, List<Filter> selectedFilters) {
    var data = _filterNames(filters);
    var filterIds = _filterIds(filters);
    var selectedFilterIds = _filterIds(selectedFilters);

    var ids = selectedFilterIds.map((filter) {
      return filterIds.indexOf(filter);
    });
    ids = ids.isEmpty ? [0] : ids;

    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: data),
        selecteds: ids ?? [0],
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
          selectedFilters = [];
          var selected = picker.selecteds;
          selected.forEach((index) {
            var filter = filters.elementAt(index);
            selectedFilters.add(filter);
          });
        });

    picker.show(_key.currentState);
  }

  Widget _sendButton() {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 60, bottom: 30),
      child: Button(label: "VER RESTAURANTES", submitted: () {}),
    );
  }

  Future<List<Filter>> _filters(Future future, String key) async {
    var filters = await this.preferences.filters(key);
    if (filters.isNotEmpty) return filters;
    Tuple2<int, List<Filter>> result = await future;
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.setFilters(result.item2, key);
        return result.item2;
        break;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }
}
