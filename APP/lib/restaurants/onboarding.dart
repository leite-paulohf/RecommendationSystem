import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/restaurants/recommendations.dart';
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
        _header("Qual é a sua culinária favorita?"),
        _selector(
          "CULINÁRIAS",
          _cuisines(),
          this.viewModel.cuisines,
          this.viewModel.cuisine,
          this.viewModel.setCuisine,
        ),
        _header("Deseja conhecer restaurantes a partir de qual avaliação?"),
        _selector(
          "AVALIAÇÕES",
          _ratings(),
          this.viewModel.ratings,
          this.viewModel.rating,
          this.viewModel.setRating,
        ),
        _header("Qual é o valor médio que deseja gastar em um restaurante?"),
        _selector(
          "VALORES",
          _prices(),
          this.viewModel.prices,
          this.viewModel.price,
          this.viewModel.setPrice,
        ),
        _header("Constuma sair para comer com quantas pessoas?"),
        _selector(
          "PESSOAS NA MESA",
          _chairs(),
          this.viewModel.chairs,
          this.viewModel.chair,
          this.viewModel.setChair,
        ),
        _header("Qual ocasião mais combina com seu perfil?"),
        _selector(
          "OCASIÕES",
          _moments(),
          this.viewModel.moments,
          this.viewModel.moment,
          this.viewModel.setMoment,
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
    Filter filter,
    Function update,
  ) {
    return FutureBuilder<List<Filter>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            filters = snapshot.data;
            return Button(
                label: filter?.name?.toUpperCase() ?? title,
                submitted: () {
                  _showPicker(filters, update);
                });
          default:
            return Button(label: title, submitted: () {});
        }
      },
    );
  }

  List<String> _names(List<Filter> filters) {
    var names = filters.map((filter) {
      return filter.name;
    }).toList();
    return names;
  }

  void _showPicker(List<Filter> filters, Function update) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _names(filters)),
        selecteds: [0],
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
          setState(() {
            var index = picker.selecteds.first;
            var filter = filters.elementAt(index);
            update(filter);
          });
        });

    picker.show(_key.currentState);
  }

  Widget _sendButton() {
    return Container(
      width: 200,
      padding: EdgeInsets.only(top: 60, bottom: 30),
      child: Button(
          label: "VER RESTAURANTES",
          submitted: () {
            if (this.viewModel.cuisine == null) {
              var text = "Selecione sua culinária favorita";
              Alert().error(context, text);
              return;
            }
            if (this.viewModel.rating == null) {
              var text = "Selecione uma avaliação inicial";
              Alert().error(context, text);
              return;
            }
            if (this.viewModel.price == null) {
              var text = "Selecione o valor médio desejado";
              Alert().error(context, text);
              return;
            }
            if (this.viewModel.chair == null) {
              var text = "Selecione uma referência de pessoas na mesa";
              Alert().error(context, text);
              return;
            }
            if (this.viewModel.moment == null) {
              var text = "Selecione um momento para comer fora";
              Alert().error(context, text);
              return;
            }
            _pushRecommendations();
          }),
    );
  }

  void _pushRecommendations() {
    Navigator.push(this.context, MaterialPageRoute(builder: (context) {
      return Recommendations(viewModel: this.viewModel);
    }));
  }

  Future<List<Filter>> _moments() async {
    var moments = await Cache().filtersCache("moments");
    if (moments.isNotEmpty) return moments;
    Tuple2<int, List<Filter>> result = await this.viewModel.momentsAPI();
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setFilters(result.item2, "moments");
        return result.item2;
        break;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Filter>> _cuisines() async {
    var cuisines = await Cache().filtersCache("cuisines");
    if (cuisines.isNotEmpty) return cuisines;
    Tuple2<int, List<Filter>> result = await this.viewModel.cuisinesAPI();
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setFilters(result.item2, "cuisines");
        return result.item2;
        break;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Filter>> _chairs() async {
    var chairs = await Cache().filtersCache("chairs");
    if (chairs.isNotEmpty) return chairs;
    Tuple2<int, List<Filter>> result = await this.viewModel.chairsAPI();
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setFilters(result.item2, "chairs");
        return result.item2;
        break;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Filter>> _prices() async {
    var prices = await Cache().filtersCache("prices");
    if (prices.isNotEmpty) return prices;
    Tuple2<int, List<Filter>> result = await this.viewModel.pricesAPI();
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setFilters(result.item2, "prices");
        return result.item2;
        break;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Filter>> _ratings() async {
    var ratings = await Cache().filtersCache("ratings");
    if (ratings.isNotEmpty) return ratings;
    Tuple2<int, List<Filter>> result = await this.viewModel.ratingAPI();
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setFilters(result.item2, "ratings");
        return result.item2;
        break;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }
}
