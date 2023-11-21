import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/Tela%20Inicial/Containeres_Tela_inicial.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/getToken.dart';

class TelaInicial extends StatefulWidget {
  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  Timer? sincronizacaoTimer;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> getdata() async {
    debugPrint("getdata tela_inicial");
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setInt('indiceatual', 0);
    var empresaid = opcs.getInt("sessionid");
    getToken().sincronizar(empresaid);
  }

  @override
  var timer = 1;
  void _decrementCounter() {
    sincronizacaoTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      setState(() {
        try {
          getdata();
        } catch (e) {
          debugPrint("error on getdata of tela_inicial: $e");
        }
      });
    });
  }

  void initState() {
    debugPrint("initState called tela_inicial");
    getdata();
    _decrementCounter();
    super.initState();
  }

  @override
  void dispose() {
    sincronizacaoTimer?.cancel();
    super.dispose();
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
        ));
  }
}
