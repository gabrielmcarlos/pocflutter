import 'package:flutter/material.dart';

class Editor extends StatelessWidget {
  final TextEditingController _controlador;
  final String _rotulo;
  final String _dica;

  Editor(this._controlador, this._rotulo, this._dica);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controlador,
        style: TextStyle(
          fontSize: 22.0,
        ),
        decoration: InputDecoration(
          labelText: _rotulo,
          hintText: _dica,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
