import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_app/helper/validator.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/helper/alert.dart';

class Register extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Register({Key key, @required this.viewModel}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Register"),
      ),
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
        model: this.widget.viewModel,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(20),
            children: <Widget>[
              _header(),
              _formName(),
              Padding(padding: EdgeInsets.only(top: 20)),
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

  Widget _formName() {
    return TextFormField(
      decoration: _decoration("Name"),
      onFieldSubmitted: (name) {
        this.widget.viewModel.name = name;
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (name) {
        this.widget.viewModel.name = name;
        if (name.isEmpty) {
          return 'The field can\'t be empty!';
        }
      },
    );
  }

  Widget _formDocument() {
    return TextFormField(
      controller: MaskedTextController(
          text: this.widget.viewModel.document, mask: '000.000.000-00'),
      decoration: _decoration("Document"),
      onFieldSubmitted: (document) {
        this.widget.viewModel.document = document;
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (document) {
        this.widget.viewModel.document = document;
        if (!CPFValidator.isValid(document)) {
          return 'Type a valid document!';
        }
      },
    );
  }

  Widget _formPassword() {
    return TextFormField(
      decoration: _decoration("Password"),
      onFieldSubmitted: (password) {
        this.widget.viewModel.password = password;
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (password) {
        this.widget.viewModel.password = password;
        if (password.length < 5) {
          return 'Type a password at least 6 characters!';
        }
      },
    );
  }

  Widget _button() {
    return Button(
      label: "REGISTER",
      submitted: () {
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
    );
  }

  void _register() async {
    var result = await this.widget.viewModel.register();
    var code = result.item1;
    switch (code) {
      case 200:
        return Alert.show(context, result.item2.toJson().toString());
      default:
        Alert.show(context, Error.from(code).message);
    }
  }
}
