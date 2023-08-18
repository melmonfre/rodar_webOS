import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/responsavel/tela_responsavel.dart';
import 'package:rodarwebos/services/conclusao/confirmaostecnicoassinatura.dart';
import 'package:rodarwebos/widgets/foto_assinatura/imagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConclusaoDadosAssinatura extends StatefulWidget {
  @override
  _TelaConclusaoDadosAssinaturaState createState() =>
      _TelaConclusaoDadosAssinaturaState();
}

class _TelaConclusaoDadosAssinaturaState
    extends State<TelaConclusaoDadosAssinatura> {
  salvanocache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var assinatura = opcs.getString("base64assinatura");
    opcs.setString("assinaturaconfirmacao", assinatura!);
  }

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
              Imagem(
                onPressed: () async {
                  await salvanocache();
                  confirmassinatura().enviar();

                  //Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaResponsavel()),
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
