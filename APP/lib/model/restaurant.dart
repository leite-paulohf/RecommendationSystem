import 'filter.dart';
import 'offer.dart';

class Restaurant {
  final bool acceptHolidays;
  final String address;
  final double price;
  final double rating;
  final Filter category;
  final int chairs;
  final Filter city;
  final Filter cuisine;
  final bool hasWifi;
  final Filter id;
  final Filter kind;
  final double latitude;
  final double longitude;
  final Filter moment;
  final String name;
  final Filter neighborhood;
  final Offer offer;

  Restaurant({
    this.acceptHolidays,
    this.address,
    this.price,
    this.rating,
    this.category,
    this.chairs,
    this.city,
    this.cuisine,
    this.hasWifi,
    this.id,
    this.kind,
    this.latitude,
    this.longitude,
    this.moment,
    this.name,
    this.neighborhood,
    this.offer,
  });

  factory Restaurant.fromModel(Map<String, dynamic> model) {
    return Restaurant(
      acceptHolidays: model['accept_holidays'],
      address: model['address'],
      price: model['average_cost'],
      rating: model['average_rating'],
      category: Filter.fromModel(model['category']),
      chairs: model['chairs'],
      city: Filter.fromModel(model['city']),
      cuisine: Filter.fromModel(model['cuisine']),
      hasWifi: model['has_wifi'],
      id: model['id'],
      kind: Filter.fromModel(model['kind']),
      latitude: model['latitude'],
      longitude: model['longitude'],
      moment: Filter.fromModel(model['moment']),
      name: model['name'],
      neighborhood: Filter.fromModel(model['neighborhood']),
      offer: Offer.fromModel(model['offer']),
    );
  }

  Map<String, dynamic> toJson() => {
        'accept_holidays': this.acceptHolidays,
        'address': this.address,
        'average_cost': this.price,
        'average_rating': this.rating,
        'category': this.category,
        'chairs': this.chairs,
        'city': this.city,
        'cuisine': this.cuisine,
        'has_wifi': this.hasWifi,
        'id': this.id,
        'kind': this.kind,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'moment': this.moment,
        'name': this.name,
        'neighborhood': this.neighborhood,
        'offer': this.offer,
      };
}
