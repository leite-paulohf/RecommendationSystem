class Filter {
	final int id;
	final String name;

	Filter({this.id, this.name});

	factory Filter.fromJson(Map<String, dynamic> json) {
		return Filter(id: json['id'], name: json['name']);
	}

	Map<String, dynamic> toJson() => {'id': this.id, 'name': this.name};
}