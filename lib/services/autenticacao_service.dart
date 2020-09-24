import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:revendas/models/usuario.dart';

class AutenticacaoService {
  // static const AUTH0_DOMAIN = 'revendasflutter.us.auth0.com';
  // static const AUTH0_CLIENT_ID = 'bvYcKoJxykRhLhjN5eIeWWLG8RgxaxqG';

  // static const AUTH0_REDIRECT_URI = 'com.example.revendas://login-callback';
  // static const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';


  static const AUTH0_DOMAIN = 'https://wso2identity.hom.sicredi.net/oauth2/token';
  static const AUTH0_CLIENT_ID = 'uEkzFi8Fzy4kB6dcBRTiNosgNTsa';

  static const AUTH0_REDIRECT_URI = 'com.example.revendas://login-callback';
  static const AUTH0_DISCOVERY_URI = 'https://wso2identity.hom.sicredi.net/oauth2/oidcdiscovery/.well-known/openid-configuration';
  static const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN/oauth2/token';

  final FlutterAppAuth appAuth = FlutterAppAuth();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Usuario usuarioLogado;

  Map<String, dynamic> parseIdToken(String idToken) {
    final parts = idToken.split(r'.');
    assert(parts.length == 3);

    return jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, dynamic>> getUserDetails(String accessToken) async {
    final url = 'https://$AUTH0_DOMAIN/userinfo';
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      debugPrint('Response: ' + response.body.toString());

      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  Future<Usuario> autenticar() async {
    try {
      final AuthorizationTokenResponse result =
          await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AUTH0_CLIENT_ID,
          AUTH0_REDIRECT_URI,
          discoveryUrl: AUTH0_DISCOVERY_URI,
          issuer: 'https://$AUTH0_DOMAIN',
          scopes: ['openid', 'profile', 'offline_access'],
        ),
      );

      final idToken = parseIdToken(result.idToken);
      debugPrint('Token: ' + idToken.toString());

      final profile = await getUserDetails(result.accessToken);

      await secureStorage.write(
          key: 'refresh_token', value: result.refreshToken);

      this.usuarioLogado = Usuario(idToken['name'].toString());
      return this.usuarioLogado;
    } catch (e, s) {
      print('login error: $e - stack: $s');
      return null;
    }
  }

  void logoutAction() async {
    await secureStorage.delete(key: 'refresh_token');
  }
}
