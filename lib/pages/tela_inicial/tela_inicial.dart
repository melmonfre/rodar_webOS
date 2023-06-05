import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:rodarwebos/widgets/Tela%20Inicial/Containeres_Tela_inicial.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centraliza o título na AppBar
        title: Text('Ordens de serviço'),
      ),
      drawer: AppDrawer(),
      body: ContainerContent(),
    );
  }
}
