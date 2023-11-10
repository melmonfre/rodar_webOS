import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/conclusao/confirmacaopresencial.dart';
import 'package:rodarwebos/services/conclusao/envianotificacaocontato.dart';
import 'package:rodarwebos/services/conclusao/enviardocumentopresencial.dart';
import 'package:rodarwebos/services/conclusao/reenviarconfirmacao.dart';
import 'package:rodarwebos/widgets/responsavel/container_responsavel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaResponsavel extends StatefulWidget {
  @override
  _TelaResponsavelState createState() => _TelaResponsavelState();
}

class _TelaResponsavelState extends State<TelaResponsavel> {
  var os;
  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    setState(() {
      os = element['id'];
    });
  }

  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Responsavel'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$os",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ContainerResponsavel(
                onPressed: () {
                  confirmacaopresencial().enviar();
                  enviardocconfirmacaopresencial().enviar();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
