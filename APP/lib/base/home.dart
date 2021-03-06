import 'package:flutter/material.dart';
import 'package:tcc_app/authentication/authentication.dart';
import 'package:tcc_app/usages/usages.dart';
import 'package:tcc_app/favorites/favorites.dart';
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
    Favorites(),
    Authentication()
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
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
          title: Text('Restaurantes'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          title: Text('Histórico'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          title: Text('Favoritos'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          title: Text('Perfil'),
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
