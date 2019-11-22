class Filter {
  final int id;
  final String name;

  Filter({
    this.id,
    this.name,
  });

  factory Filter.fromModel(Map<String, dynamic> model) {
    return Filter(
      id: model['id'],
      name: model['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
      };
}
