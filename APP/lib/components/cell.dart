import 'package:flutter/material.dart';
import 'package:tcc_app/model/restaurant.dart';

class Cell extends StatelessWidget {
  final Restaurant restaurant;
  final Function booking, favorite;
  var size;

  Cell({
    @required this.restaurant,
    @required this.booking,
    @required this.favorite,
  });

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
          onTap: () {
            this.booking(this.restaurant);
          },
          child: _cell()),
    );
  }

  Widget _cell() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        image: DecorationImage(
          image: AssetImage('assets/login.jpg'),
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
    double width = (this.size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              this.favorite(this.restaurant);
            }),
      ),
    );
  }

  Widget _ratingRange() {
    double width = (this.size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(alignment: AlignmentDirectional.topEnd, child: _rating()),
    );
  }

  Widget _rating() {
    switch (this.restaurant.rating.round()) {
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
      width: this.size.width - 16,
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
    var price = this.restaurant.price.round();
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
    double width = 2 * this.size.width / 3 - 8;
    return Container(
        width: width,
        padding: EdgeInsets.all(8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: _label(this.restaurant.name, 20),
        ));
  }

  Widget _cuisine() {
    var cuisine = this.restaurant.cuisine.name;
    double width = this.size.width / 3 - 8;
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
    var neighborhood = this.restaurant.neighborhood.name;
    var city = this.restaurant.city.name;
    var location = city + " - " + neighborhood;
    double width = 2 * this.size.width / 3 - 8;
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
    var category = this.restaurant.category.name;
    double width = this.size.width / 3 - 8;
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
    var address = this.restaurant.address;
    double width = this.size.width - 16;
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
}
