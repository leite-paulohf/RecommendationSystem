import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/favourites/viewmodel.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/favourites.dart';

class Favourites extends StatefulWidget {
  Favourites({Key key}) : super(key: key);

  @override
  FavouritesState createState() => FavouritesState();
}

class FavouritesState extends State<Favourites> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = FavouritesViewModel(interface: FavouritesService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      body: _body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body() {
    return FutureBuilder<List<Restaurant>>(
      future: _getAllFavourites(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ScopedModel<FavouritesViewModel>(
                model: this.viewModel,
                child: TableView(
                  restaurants: snapshot.data ?? [],
                  booking: _removeFavourite,
                  favourite: _addFavourite,
                ));
          default:
            return Loader().show();
        }
      },
    );
  }

  Future<List<Restaurant>> _getAllFavourites() async {
    var result = await this.viewModel.getAllFavourites();
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _addFavourite() async {
    var result = await this.viewModel.addFavourite();
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _removeFavourite() async {
    var result = await this.viewModel.removeFavourite();
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }
}
