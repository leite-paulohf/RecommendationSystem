import 'package:flutter/material.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/service/favorites.dart';

class Cell extends StatefulWidget {
  final Restaurant restaurant;
  final Function booking, favorite;

  Cell({
    Key key,
    @required this.restaurant,
    @required this.booking,
    @required this.favorite,
  }) : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final preferences = Preferences();
  Size _size;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
          onTap: () {
            this.widget.booking(this.widget.restaurant);
          },
          child: _cell()),
    );
  }

  Widget _cell() {
    var id = this.widget.restaurant.cuisine.id.toString();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
          image: AssetImage('assets/cuisine-$id.jpg'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Column(
        children: <Widget>[
          _banner(),
          _detail(),
        ],
      ),
    );
  }

  Widget _banner() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            _ratingRange(),
            _favourite(),
          ]),
          _priceRange(),
        ],
      ),
    );
  }

  Widget _favourite() {
    double width = (_size.width / 2) - 8;
    return FutureBuilder<List<int>>(
      future: _favorites(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var restaurants = snapshot.data ?? [];
            var restaurant = this.widget.restaurant.id;
            var favorite = restaurants.contains(restaurant);
            return _favouriteButton(favorite);
          default:
            return Container(height: 75, width: width);
        }
      },
    );
  }

  Widget _favouriteButton(bool favorite) {
    double width = (_size.width / 2) - 8;
    var icon = favorite ? Icons.favorite : Icons.favorite_border;
    var color = favorite ? Colors.redAccent : Colors.white;
    return Container(
      height: 75,
      width: width,
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
            icon: Icon(icon, color: color),
            onPressed: () {
              this.widget.favorite(this.widget.restaurant);
            }),
      ),
    );
  }

  Widget _ratingRange() {
    double width = (_size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(alignment: AlignmentDirectional.topEnd, child: _rating()),
    );
  }

  Widget _rating() {
    switch (this.widget.restaurant.rating.round()) {
      case 1:
        return Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
        ]);
      case 2:
        return Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
        ]);
      case 3:
        return Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
        ]);
      case 4:
        return Row(children: <Widget>[
          Icon(Icons.star_border, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
        ]);
      case 5:
        return Row(children: <Widget>[
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
          Icon(Icons.star, color: Colors.orangeAccent),
        ]);
      default:
        return Container();
    }
  }

  Widget _priceRange() {
    return Container(
      height: 75,
      width: _size.width - 16,
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Text(
          _price(),
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String _price() {
    var price = this.widget.restaurant.price.round();
    return "Preço médio: " + r"R$" + price.toString();
  }

  Widget _detail() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          )),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[_name(), _cuisine()]),
          Row(children: <Widget>[_location(), _category()]),
          _address()
        ],
      ),
    );
  }

  Widget _name() {
    double width = 2 * _size.width / 3 - 8;
    return Container(
        width: width,
        padding: EdgeInsets.all(8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: _label(this.widget.restaurant.name, 20),
        ));
  }

  Widget _cuisine() {
    var cuisine = this.widget.restaurant.cuisine.name;
    double width = _size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: _label(cuisine, 20),
      ),
    );
  }

  Widget _location() {
    var neighborhood = this.widget.restaurant.neighborhood.name;
    var city = this.widget.restaurant.city.name;
    var location = city + " - " + neighborhood;
    double width = 2 * _size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: _label(location, 15),
      ),
    );
  }

  Widget _category() {
    var category = this.widget.restaurant.category.name;
    double width = _size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: _label(category, 15),
      ),
    );
  }

  Widget _address() {
    var address = this.widget.restaurant.address;
    double width = _size.width - 16;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: _label(address, 15),
      ),
    );
  }

  Widget _label(String text, double size) {
    return Text(text,
        overflow: TextOverflow.fade,
        maxLines: 1,
        softWrap: false,
        style: TextStyle(
          color: Colors.black87,
          fontSize: size,
          fontWeight: FontWeight.w400,
        ));
  }

  Future<List<int>> _favorites() async {
    var user = await this.preferences.user();
    if (user.id == null) return [];
    var restaurants = await this.preferences.restaurants(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      this.preferences.set(result.item2, user.id, "favorites");
      restaurants = result.item2;
    }

    var ids = restaurants.map((restaurant) {
      return restaurant.id;
    }).toList();

    return ids;
  }
}
