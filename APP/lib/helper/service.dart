import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tcc_app/model/user.dart';
import 'package:tuple/tuple.dart';

class Service {
  final _base = '46da4ffc.ngrok.io';

  Future<http.Response> get(String path, Map<String, String> data) async {
    var url = Uri.http(_base, path, data);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var response = await http.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<http.Response> post(String path, Map data) async {
    var url = Uri.http(_base, path);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var body = json.encode(data);
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Tuple2<int, User> parse(http.Response response) {
    try {
      var user = User.fromJson(json.decode(response.body));
      return Tuple2<int, User>(response.statusCode, user);
    } catch (error) {
      return Tuple2<int, User>(response.statusCode, User());
    }
  }
}
