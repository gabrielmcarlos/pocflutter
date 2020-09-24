import 'package:flutter/material.dart';

class ListaPropostas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: <Widget>[
        Proposta('Trator', 'RS 1000,00'),
        Proposta('Colheitadeira', 'RS 1000,01')
      ]),
      appBar: AppBar(
        title: Text('Propostas'),
      ),
    );
  }
}

class Proposta extends StatelessWidget {
  final String descricao;
  final String valorFinanciado;

  Proposta(this.descricao, this.valorFinanciado);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.monetization_on),
        title: Text(descricao),
        subtitle: Text(valorFinanciado),
      ),
    );
  }
}
