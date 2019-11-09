import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/helper/validator.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/user.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = AuthenticationViewModel(interface: UserService());
  final preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("Bem Vindo!")),
      body: Container(
        child: Text("Hello World!"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
