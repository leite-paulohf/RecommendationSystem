import 'package:flutter/material.dart';
import 'package:tcc_app/model/restaurant.dart';

class Cell extends StatelessWidget {
  final Restaurant restaurant;
  final Function booking, favourite;

  BuildContext _context;

  Cell(
      {@required this.restaurant,
      @required this.booking,
      @required this.favourite});

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: _cell(),
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
          Row(children: <Widget>[_ratingRange(), _favourite()]),
          _priceRange()
        ],
      ),
    );
  }

  Widget _favourite() {
    double width = (MediaQuery.of(_context).size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
      child: Align(
        alignment: AlignmentDirectional.topEnd,
        child: IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: this.favourite),
      ),
    );
  }

  Widget _ratingRange() {
    double width = (MediaQuery.of(_context).size.width / 2) - 8;
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
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: Text(
          _price(),
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
    return r"R$" + price.toString();
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
          Row(
            children: <Widget>[_name(), _cuisine()],
          ),
          Row(
            children: <Widget>[_address(), _category()],
          )
        ],
      ),
    );
  }

  Widget _name() {
    double width = 2 * MediaQuery.of(_context).size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          this.restaurant.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _cuisine() {
    double width = MediaQuery.of(_context).size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          this.restaurant.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _address() {
    var neighborhood = this.restaurant.neighborhood.name;
    var city = this.restaurant.city.name;
    var address = neighborhood + " - " + city;
    double width = 2 * MediaQuery.of(_context).size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          address,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _category() {
    double width = MediaQuery.of(_context).size.width / 3 - 8;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Text(
          this.restaurant.category.name,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
