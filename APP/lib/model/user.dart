class User {
  int id;
  String name;
  int cpf;
  int cityId;
  String password;

  User({this.id, this.name, this.cpf, this.cityId, this.password});

  factory User.fromModel(Map<String, dynamic> json) {
    var model = json['data'];
    return User(
        id: model['id'],
        name: model['name'],
        cpf: model['cpf'],
        cityId: model['city_id'],
        password: model['password']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'city_id': cityId,
        'password': password,
      };
}
