import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rodarwebos/pages/login/tela_login.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/todos_containers.dart';

import 'link/linkexterno.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LinkHandler linkHandler = LinkHandler();
  await linkHandler.initUrlLaunch();
  ByteData data = await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(MyApp(linkHandler: linkHandler));
}


class MyApp extends StatefulWidget {
  final LinkHandler linkHandler;

  const MyApp({Key? key, required this.linkHandler}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool shouldShowLogin = true; // Variável de estado para controlar a exibição da tela de login

  @override
  void initState() {
    super.initState();
    // Verifica se o aplicativo foi aberto por um link externo
    widget.linkHandler.initUrlLaunch().then((_) {
      setState(() {
        // Atualiza a variável de estado para exibir a tela inicial em vez da tela de login
        shouldShowLogin = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF26738E), // Define a cor da AppBar
      ),
      // home: TelaInicial(),
      home: shouldShowLogin ? loginTeste('teste') : TelaInicial(),
    );
  }
}

