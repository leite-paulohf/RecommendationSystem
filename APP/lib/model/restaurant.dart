import 'filter.dart';

class Restaurant {
  final int id;
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

  Restaurant({
    this.id,
    this.name,
    this.discount,
    this.price,
    this.rating,
    this.kind,
    this.city,
    this.neighbourhood,
    this.cuisine,
    this.category,
    this.moment,
  });

  factory Restaurant.fromModel(Map<String, dynamic> model) {
    return Restaurant(
      id: model['uuid'],
      name: model['name'],
      discount: model['discount'],
      price: model['price_range'],
      rating: model['rating'],
      kind: Filter.fromModel(model['kind']),
      city: Filter.fromModel(model['city']),
      neighbourhood: Filter.fromModel(model['neighbourhood']),
      cuisine: Filter.fromModel(model['cuisine']),
      category: Filter.fromModel(model['category']),
      moment: Filter.fromModel(model['moment']),
    );
  }

  Map<String, dynamic> toJson() => {
        'uuid': this.id,
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
