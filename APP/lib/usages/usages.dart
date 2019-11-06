import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/usages.dart';
import 'package:tcc_app/usages/viewmodel.dart';

class Usages extends StatefulWidget {
  Usages({Key key}) : super(key: key);

  @override
  UsagesState createState() => UsagesState();
}

class UsagesState extends State<Usages> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = UsagesViewModel(interface: UsagesService());

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
      future: _search(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ScopedModel<UsagesViewModel>(
                model: this.viewModel,
                child: TableView(
                  direction: Axis.vertical,
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

  Future<List<Restaurant>> _search() async {
    var result = await this.viewModel.search(1);
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
