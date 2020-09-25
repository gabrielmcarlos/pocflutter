import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:revendas/components/editor.dart';
import 'package:revendas/screens/lista_propostas.dart';
import 'package:revendas/services/autenticacao_service.dart';
class Autenticacao extends StatelessWidget {
  final TextEditingController _controladorCampoLogin = TextEditingController();
  final TextEditingController _controladorCampoSenha = TextEditingController();

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Editor(_controladorCampoLogin, 'login', 'usuario_teste'),
          Editor(_controladorCampoSenha, 'senha', 'xxxx'),
          RaisedButton(
            child: Text('Autenticar'),
            onPressed: () {
             this.autenticar(context);
            },
          )
        ],
      ),
      appBar: AppBar(
        title: Text('Autenticação'),
      ),
    );
  }

  void autenticar(BuildContext context) async {
    final usuarioLogado = await AutenticacaoService().autenticar();
    if (usuarioLogado != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ListaPropostas();
      }));
    } else {
      debugPrint('Erro ao autenticar');
    }
  }
}
