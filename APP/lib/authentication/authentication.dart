import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/helper/validator.dart';
import 'login.dart';
import 'register.dart';
import 'viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/service/user.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/helper/alert.dart';

class Authentication extends StatefulWidget {
  Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final viewModel = AuthenticationViewModel(interface: UserService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: _body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body() {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ScopedModel<AuthenticationViewModel>(
            model: this.viewModel,
            child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: <Widget>[
                    _header(),
                    _form(),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    _button()
                  ],
                ))));
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Icon(
        Icons.account_circle,
        color: Colors.teal,
        size: 50,
      ),
    );
  }

  Widget _form() {
    return TextFormField(
        controller: MaskedTextController(mask: '000.000.000-00'),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelText: "Document", border: OutlineInputBorder()),
        onFieldSubmitted: (document) {
          this.viewModel.document = document;
          if (_formKey.currentState.validate()) {
            _search();
          }
        },
        validator: (document) {
          this.viewModel.document = document;
          if (!CPFValidator.isValid(document)) {
            return 'Type a valid document!';
          }
        });
  }

  Widget _button() {
    return Button(
        label: "CONTINUE",
        submitted: () {
          if (_formKey.currentState.validate()) {
            _search();
          }
        });
  }

  void _search() async {
    var result = await this.viewModel.search();
    var code = result.item1;
    switch (code) {
      case 200:
        return _pushLogin();
      case 404:
        return _pushRegister();
      default:
        Alert.show(context, Error.from(code).message);
    }
  }

  void _pushLogin() {
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) {
        return Login(viewModel: this.viewModel);
      }),
    );
  }

  void _pushRegister() {
    Navigator.push(
      this.context,
      MaterialPageRoute(builder: (context) {
        return Register(viewModel: this.viewModel);
      }),
    );
  }
}