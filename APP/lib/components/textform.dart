import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  final _key = GlobalKey<FormState>();
  final Function submitted;
  final String label;

  TextForm({@required this.label, @required this.submitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: _form(),
    );
  }

  Widget _form() {
    return Form(
        key: _key,
        child: TextFormField(
            decoration: InputDecoration(
                labelText: this.label, border: OutlineInputBorder()),
            onFieldSubmitted: (value) {
              if (_key.currentState.validate()) {
                this.submitted(value);
              }
            },
            validator: (text) {
              if (text.isEmpty) {
                return 'The field can\'t be empty!';
              }
            }));
  }
}
