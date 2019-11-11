import 'package:flutter/material.dart';
import 'package:tcc_app/model/restaurant.dart';

class Cell extends StatefulWidget {
  final Size size;
  final Restaurant restaurant;
  final bool favorited, preference, liked;
  final Function booking, favorite, like, unlike;

  Cell({
    Key key,
    @required this.size,
    @required this.restaurant,
    @required this.favorited,
    @required this.preference,
    @required this.liked,
    @required this.booking,
    @required this.favorite,
    @required this.like,
    @required this.unlike,
  }) : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  bool _favorited;
  Restaurant _restaurant;

  @override
  Widget build(BuildContext context) {
    _favorited = this.widget.favorited;
    _restaurant = this.widget.restaurant;
    return Padding(
      padding: EdgeInsets.all(8),
      child: GestureDetector(
          onTap: () {
            this.widget.booking(_restaurant);
          },
          child: _cell()),
    );
  }

  Widget _cell() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
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
    var id = this.widget.restaurant.cuisine.id.toString();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/cuisine-$id.jpg'),
            fit: BoxFit.fitWidth,
            colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(children: <Widget>[
            _ratingRange(),
            _favouriteButton(),
          ]),
          Row(children: <Widget>[
            _discount(),
            _priceRange(),
          ]),
        ],
      ),
    );
  }

  Widget _favouriteButton() {
    double width = (this.widget.size.width / 2) - 8;
    var icon = _favorited ? Icons.favorite : Icons.favorite_border;
    var color = _favorited ? Colors.redAccent : Colors.white;
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
    double width = (this.widget.size.width / 2) - 8;
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

  Widget _discount() {
    var discount = this.widget.restaurant.offer.discount;
    var text = discount > 0 ? "$discount%OFF" : "Sem desconto";
    double width = (this.widget.size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
      padding: EdgeInsets.all(8),
      child: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Text(
          text,
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

  Widget _priceRange() {
    double width = (this.widget.size.width / 2) - 8;
    return Container(
      height: 75,
      width: width,
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
          _address(),
          _preferenceView(
            this.widget.preference ?? false,
            this.widget.liked ?? false,
          ),
        ],
      ),
    );
  }

  Widget _preferenceView(bool preference, bool liked) {
    if (!preference) return Container();
    if (liked) return _likedView();
    return _preferenceButtons();
  }

  Widget _likedView() {
    return Container(
      height: 48,
      width: this.widget.size.width - 16,
      padding: EdgeInsets.only(left: 8),
      child: Row(children: <Widget>[
        Icon(Icons.check_circle, color: Colors.lightGreen),
        Text(" Aprovado!"),
      ]),
    );
  }

  Widget _preferenceButtons() {
    return Container(
      height: 48,
      width: this.widget.size.width - 16,
      padding: EdgeInsets.only(left: 8),
      child: Row(children: <Widget>[
        Text("Aprovado:"),
        IconButton(
            icon: Icon(
              Icons.check_circle,
              color: Colors.lightGreen,
            ),
            onPressed: () {
              this.widget.like(this.widget.restaurant);
            }),
        Text("Reprovado:"),
        IconButton(
            icon: Icon(
              Icons.cancel,
              color: Colors.redAccent,
            ),
            onPressed: () {
              this.widget.like(this.widget.restaurant);
            }),
      ]),
    );
  }

  Widget _name() {
    double width = this.widget.size.width / 2 - 8;
    return Container(
        width: width+28,
        padding: EdgeInsets.all(8),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: _label(this.widget.restaurant.name, 20),
        ));
  }

  Widget _cuisine() {
    var cuisine = this.widget.restaurant.cuisine.name;
    double width = this.widget.size.width / 2 - 8;
    return Container(
      width: width-28,
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
    double width = 2 * this.widget.size.width / 3 - 8;
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
    double width = this.widget.size.width / 3 - 8;
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
    double width = this.widget.size.width - 16;
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
