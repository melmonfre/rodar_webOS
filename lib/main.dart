import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/login/tela_login.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/httpfix.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/todos_containers.dart';

import 'link/linkexterno.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LinkHandler linkHandler = LinkHandler();
  await linkHandler.initUrlLaunch();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(linkHandler: linkHandler));
}

class MyApp extends StatefulWidget {
  final LinkHandler linkHandler;

  const MyApp({Key? key, required this.linkHandler}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF26738E), // Define a cor da AppBar
      ),
      // home: TelaInicial(),
      home: loginTeste('token'),
    );
  }
}

