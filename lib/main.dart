import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/revenda_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(await addSelfSignedCertificate());
  HttpOverrides.global = new MyHttpOverrides();
  runApp(RevendaApp());
}

Future<bool> addSelfSignedCertificate() async {
  ByteData data = await rootBundle.load('assets/certs/raiz.crt');
  SecurityContext context = SecurityContext.defaultContext;
  context.setTrustedCertificatesBytes(data.buffer.asUint8List());

  ByteData data2 = await rootBundle.load('assets/certs/intermediario.crt');
  context.setTrustedCertificatesBytes(data2.buffer.asUint8List());

  ByteData data3 = await rootBundle.load('assets/certs/intermediario2.crt');
  context.setTrustedCertificatesBytes(data3.buffer.asUint8List());

  ByteData data4 = await rootBundle.load('assets/certs/intermediario3.crt');
  context.setTrustedCertificatesBytes(data4.buffer.asUint8List());

  ByteData data5 = await rootBundle.load('assets/certs/intermediario4.crt');
  context.useCertificateChainBytes(data5.buffer.asUint8List());
  return true;
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
