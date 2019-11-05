import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/validator.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:flutter_picker/flutter_picker.dart';

class Register extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Register({Key key, @required this.viewModel}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
      appBar: AppBar(
        title: Text("Register"),
      ),
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
              _citySelector(),
              Padding(padding: EdgeInsets.only(top: 20)),
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
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
    );
  }

  Widget _citySelector() {
    return FutureBuilder<List<Filter>>(
      future: this.widget.viewModel.getCities(context),
      builder: (context, snapshot) {
        var city = this.widget.viewModel.city;
        var title = city?.name?.toUpperCase() ?? "SELECT CITY";
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var cities = snapshot.data;
            cities.sort((e1, e2) {
              return e1.name.toLowerCase().compareTo(e2.name.toLowerCase());
            });
            this.widget.viewModel.cities = cities;
            return Button(label: title, submitted: _showPicker);
          default:
            return Button(label: title, submitted: () {});
        }
      },
    );
  }

  void _showPicker() {
    var cities = this.widget.viewModel.cities.map((city) {
      return city.name;
    }).toList();
    var city = this.widget.viewModel.city?.name ?? "";
    var index = cities.indexOf(city);
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: cities),
        selecteds: [index],
        height: 200,
        itemExtent: 40,
        changeToFirst: true,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
        cancelText: "CANCEL",
        cancelTextStyle: TextStyle(color: Colors.teal),
        confirmText: "CONFIRM",
        confirmTextStyle: TextStyle(color: Colors.teal),
        textAlign: TextAlign.left,
        columnPadding: const EdgeInsets.all(16.0),
        onConfirm: (Picker picker, List value) {
          setState(() {
            var index = picker.selecteds.first;
            var city = this.widget.viewModel.cities[index];
            this.widget.viewModel.city = city;
            this.widget.viewModel.user.cityId = city.id;
          });
        });
    picker.show(_key.currentState);
  }

  Widget _formName() {
    return TextFormField(
      decoration: _decoration("Name"),
      onFieldSubmitted: (name) {
        this.widget.viewModel.user.name = name;
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (name) {
        this.widget.viewModel.user.name = name;
        if (name.isEmpty) {
          return 'The field can\'t be empty!';
        }
      },
    );
  }

  Widget _formDocument() {
    return TextFormField(
      controller: MaskedTextController(
          text: this.widget.viewModel.user.cpf.toString(),
          mask: '000.000.000-00'),
      decoration: _decoration("Document"),
      onFieldSubmitted: (cpf) {
        cpf = cpf.replaceAll('.', '').replaceAll('-', '');
        this.widget.viewModel.user.cpf = int.parse(cpf);
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (cpf) {
        cpf = cpf.replaceAll('.', '').replaceAll('-', '');
        this.widget.viewModel.user.cpf = int.parse(cpf);
        if (!CPFValidator.isValid(cpf)) {
          return 'Type a valid document!';
        }
      },
    );
  }

  Widget _formPassword() {
    return TextFormField(
      decoration: _decoration("Password"),
      onFieldSubmitted: (password) {
        this.widget.viewModel.user.password = password;
        if (_formKey.currentState.validate()) {
          _register();
        }
      },
      validator: (password) {
        this.widget.viewModel.user.password = password;
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
          if (this.widget.viewModel.city != null) {
            _register();
          }
        }
      },
    );
  }

  void _register() async {
    this.loading = true;
    var result = await this.widget.viewModel.register();
    this.loading = false;
    var code = result.item1;
    switch (code) {
      case 200:
        this.widget.viewModel.set(result.item2);
        Navigator.pop(context);
        break;
      default:
        Alert.show(context, Error.from(code).message);
    }
  }
}
