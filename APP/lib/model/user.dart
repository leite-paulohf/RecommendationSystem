class User {
  final String id;
  final String name;
  final String cpf;
  final String password;

  User({this.id, this.name, this.cpf, this.password});

  factory User.fromModel(Map<String, dynamic> json) {
    var model = json['data'];
    return User(
        id: model['id'],
        name: model['name'],
        cpf: model['cpf'],
        password: model['password']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cpf': cpf,
        'password': password,
      };
}
