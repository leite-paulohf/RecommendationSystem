class Offer {
  final int id;
  final int discount;
  final bool benefits;
  final bool restrictions;

  Offer({
    this.id,
    this.discount,
    this.benefits,
    this.restrictions,
  });

  factory Offer.fromModel(Map<String, dynamic> model) {
    return Offer(
      id: model['id'],
      discount: model['discount'],
      benefits: model['benefits'],
      restrictions: model['restrictions'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'discount': this.discount,
        'benefits': this.benefits,
        'restrictions': this.restrictions,
      };
}
