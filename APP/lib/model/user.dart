class User {
  final String uuid;
  final String name;
  final String document;
  final String password;

  User({this.uuid, this.name, this.document, this.password});

  factory User.fromModel(Map<String, dynamic> json) {
    var model = json['data'];
    return User(
        uuid: model['uuid'],
        name: model['name'],
        document: model['document'],
        password: model['password']);
  }

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'name': name,
        'document': document,
        'password': password,
      };
}
