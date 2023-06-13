import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:rodarwebos/widgets/Tela%20Inicial/Containeres_Tela_inicial.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _refreshIndicatorKey.currentState?.show();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, // Centraliza o título na AppBar
        title: Text('Ordens de serviço'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
      key: _refreshIndicatorKey,
      color: Colors.white,
      backgroundColor: Color(0xFF26738e),
      strokeWidth: 4.0,
      onRefresh: () async {
        return Future<void>.delayed(const Duration(seconds: 5));
      },
      child: ContainerContent(),
    )
    );
  }
}
