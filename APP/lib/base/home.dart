import 'package:flutter/material.dart';
import 'package:tcc_app/authentication/authentication.dart';
import 'package:tcc_app/usages/usages.dart';
import 'package:tcc_app/favourites/favourites.dart';
import 'package:tcc_app/restaurants/restaurants.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  final List<Widget> _body = [
    Restaurants(),
    Usages(),
    Favourites(),
    Authentication()
  ];

  final _title = ["Restaurants", "Usages", "Favourites", "Profile"];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text(_title[_index]),
          centerTitle: true,
        ),
        body: _body[_index],
        bottomNavigationBar: _bottomNavigationBar());
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          title: Text('Restaurants'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text('Usages'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text('Favourites'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Profile'),
        ),
      ],
      currentIndex: this._index,
      selectedItemColor: Colors.teal,
      onTap: (index) {
        setState(() {
          this._index = index;
        });
      },
    );
  }
}
