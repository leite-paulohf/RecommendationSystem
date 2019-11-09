import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
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
  final preferences = Preferences();

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
        title: Text("Registro"),
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
      future: _regions(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            this.widget.viewModel.cities = snapshot.data;
            var city = this.widget.viewModel.city;
            var title = city?.name?.toUpperCase() ?? "SELECIONE SUA CIDADE";
            return Button(label: title, submitted: _showPicker);
          default:
            return Button(label: "CARREGANDO...", submitted: () {});
        }
      },
    );
  }

  List<String> _cityNames() {
    var cities = this.widget.viewModel.cities.map((city) {
      return city.name;
    }).toList();
    return cities;
  }

  List<int> _cityIds() {
    var cities = this.widget.viewModel.cities.map((city) {
      return city.id;
    }).toList();
    return cities;
  }

  void _showPicker() {
    var cityId = this.widget.viewModel.city?.id ?? 10;
    var index = _cityIds().indexOf(cityId);
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: _cityNames()),
        selecteds: [index],
        height: 200,
        itemExtent: 40,
        changeToFirst: true,
        textStyle: TextStyle(color: Colors.black, fontSize: 20),
        cancelText: "CANCELAR",
        cancelTextStyle: TextStyle(color: Colors.teal),
        confirmText: "CONFIRMAR",
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
      decoration: _decoration("Nome"),
      onFieldSubmitted: (name) {
        this.widget.viewModel.user.name = name;
        if (_formKey.currentState.validate()) {
          if (this.widget.viewModel.city != null)
            _register();
          else
            Alert.error(context, "Selecione sua cidade!");
        }
      },
      validator: (name) {
        this.widget.viewModel.user.name = name;
        if (name.isEmpty) {
          return 'O campo não pode estar vazio!';
        }
      },
    );
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
          if (this.widget.viewModel.city != null)
            _register();
          else
            Alert.error(context, "Selecione sua cidade!");
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
          if (this.widget.viewModel.city != null)
            _register();
          else
            Alert.error(context, "Selecione sua cidade!");
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
          if (this.widget.viewModel.city != null)
            _register();
          else
            Alert.error(context, "Selecione sua cidade!");
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
        this.preferences.setUser(result.item2);
        Navigator.pop(context);
        break;
      default:
        Alert.error(context, Error.from(code).message);
    }
  }

  Future<List<Filter>> _regions() async {
    var cities = await this.preferences.cities("cities");
    if (cities.isNotEmpty) return cities;
    var result = await this.widget.viewModel.regions();
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.setCities(result.item2, "cities");
        return result.item2;
        break;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }
}
