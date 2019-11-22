import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/profile.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/helper/validator.dart';
import 'package:tcc_app/model/user.dart';
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
  var _loading = false;

  set loading(bool value) {
    setState(() {
      _loading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: Cache().userCache(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data.id != null)
              return Profile(viewModel: this.viewModel);
            return Scaffold(
              key: _key,
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(title: Text("Autenticação"), centerTitle: true),
              body: Loader().body(_loading, _body()),
            );
          default:
            return Scaffold(
              key: _key,
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(),
              body: Loader().show(),
            );
        }
      },
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
                _formDocument(),
                Padding(padding: EdgeInsets.only(top: 20)),
                _button(),
              ],
            )),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Icon(Icons.account_circle, color: Colors.teal, size: 50),
    );
  }

  Widget _formDocument() {
    return TextFormField(
        controller: MaskedTextController(
            text: this.viewModel.user.cpf.toString(), mask: '000.000.000-00'),
        keyboardType: TextInputType.number,
        decoration:
            InputDecoration(labelText: "CPF", border: OutlineInputBorder()),
        onFieldSubmitted: (cpf) {
          cpf = cpf.replaceAll('.', '').replaceAll('-', '');
          this.viewModel.user.cpf = int.parse(cpf);
          if (_formKey.currentState.validate()) {
            _search();
          }
        },
        validator: (cpf) {
          cpf = cpf.replaceAll('.', '').replaceAll('-', '');
          this.viewModel.user.cpf = int.parse(cpf);
          if (!CPFValidator.isValid(cpf)) {
            return 'Digite um CPF válido!';
          }
        });
  }

  Widget _button() {
    return Button(
        label: "CONTINUAR",
        submitted: () {
          if (_formKey.currentState.validate()) {
            _search();
          }
        });
  }

  void _search() async {
    this.loading = true;
    var result = await this.viewModel.search();
    this.loading = false;
    var code = result.item1;
    switch (code) {
      case 200:
        return _pushLogin();
      case 404:
        return _pushRegister();
      default:
        Alert().error(context, Error.from(code).message);
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
