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

class Login extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Login({Key key, @required this.viewModel}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _loading = false;

  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(title: Text("Entrar")),
      body: Loader().body(_loading, _body()),
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
        model: this.widget.viewModel,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              _header(),
              _formDocument(),
              Padding(padding: EdgeInsets.only(top: 20)),
              _formPassword(),
              Padding(padding: EdgeInsets.only(top: 20)),
              _button()
            ],
          ),
        ),
      ),
    );
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

  InputDecoration _decoration(String label) {
    return InputDecoration(labelText: label, border: OutlineInputBorder());
  }

  Widget _formDocument() {
    return TextFormField(
      controller: MaskedTextController(
          text: this.widget.viewModel.user.cpf.toString(),
          mask: '000.000.000-00'),
      decoration: _decoration("CPF"),
      onFieldSubmitted: (cpf) {
        cpf = cpf.replaceAll('.', '').replaceAll('-', '');
        this.widget.viewModel.user.cpf = int.parse(cpf);
        if (_formKey.currentState.validate()) {
          _login();
        }
      },
      validator: (cpf) {
        cpf = cpf.replaceAll('.', '').replaceAll('-', '');
        this.widget.viewModel.user.cpf = int.parse(cpf);
        if (!CPFValidator.isValid(cpf)) {
          return 'Digite um CPF válido!';
        }
      },
    );
  }

  Widget _formPassword() {
    return TextFormField(
      decoration: _decoration("Senha"),
      onFieldSubmitted: (password) {
        this.widget.viewModel.user.password = password;
        if (_formKey.currentState.validate()) {
          _login();
        }
      },
      validator: (password) {
        this.widget.viewModel.user.password = password;
        if (password.length < 5) {
          return 'Digite uma senha com pelo menos 6 caracteres!';
        }
      },
    );
  }

  Widget _button() {
    return Button(
      label: "ENTRAR",
      submitted: () {
        if (_formKey.currentState.validate()) {
          _login();
        }
      },
    );
  }

  void _login() async {
    this.loading = true;
    var result = await this.widget.viewModel.login();
    this.loading = false;
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setUser(result.item2);
        Navigator.pop(context);
        break;
      default:
        Alert().error(context, Error.from(code).message);
    }
  }
}
