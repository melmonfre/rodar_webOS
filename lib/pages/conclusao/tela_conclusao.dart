import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/confirmacao_dados/tela_confirmacao_dados.dart';
import 'package:rodarwebos/services/conclusao/conclusao.dart';
import 'package:rodarwebos/widgets/conclusao/container_conclusao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConclusao extends StatefulWidget {
  @override
  _TelaConclusaoState createState() => _TelaConclusaoState();
}

class _TelaConclusaoState extends State<TelaConclusao> {
  var os;
  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    setState(() {
      os = element['id'];
      print(os);
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
        title: Text('Conclusão'),
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
              ContainerConclusao(
                //todo salvardados

                onPressed: () {
                  enviaconclusao().enviar();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaConfirmacaoDados(),
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
