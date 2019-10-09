import 'filter.dart';

class Restaurant {
  final String uuid;
  final String name;
  final int discount;
  final int price;
  final int rating;
  final Filter kind;
  final Filter city;
  final Filter neighbourhood;
  final Filter cuisine;
  final Filter category;
  final Filter moment;

  Restaurant(
      {this.uuid,
      this.name,
      this.discount,
      this.price,
      this.rating,
      this.kind,
      this.city,
      this.neighbourhood,
      this.cuisine,
      this.category,
      this.moment});

  factory Restaurant.fromModel(Map<String, dynamic> model) {
    return Restaurant(
        uuid: model['uuid'],
        name: model['name'],
        discount: model['discount'],
        price: model['price'],
        rating: model['rating'],
        kind: model['kind'],
        city: model['city'],
        neighbourhood: model['neighbourhood'],
        cuisine: model['cuisine'],
        category: model['category'],
        moment: model['moment']);
  }

  Map<String, dynamic> toJson() => {
        'uuid': this.uuid,
        'name': this.name,
        'discount': this.discount,
        'price': this.price,
        'rating': this.rating,
        'kind': this.kind,
        'city': this.city,
        'neighbourhood': this.neighbourhood,
        'cuisine': this.cuisine,
        'category': this.category,
        'moment': this.moment
      };
}
