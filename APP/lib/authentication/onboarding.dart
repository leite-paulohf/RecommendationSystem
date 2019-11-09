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

class OnBoarding extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  OnBoarding({Key key, @required this.viewModel}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final _key = GlobalKey<ScaffoldState>();
  final preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("Bem Vindo!")),
      body: Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
