import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/OS/ConcluirOS.dart';
import 'package:rodarwebos/widgets/foto_assinatura/imagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Sincronizar/sincronizarOffline.dart';

class TelaColetarAssinaturaResponsavel extends StatefulWidget {
  @override
  _TelaColetarAssinaturaResponsavelState createState() =>
      _TelaColetarAssinaturaResponsavelState();
}

class _TelaColetarAssinaturaResponsavelState
    extends State<TelaColetarAssinaturaResponsavel> {
  salvanocache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var assinatura = opcs.getString("base64assinatura");
    opcs.setString("assinaturaresponsavel", assinatura!);
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

  Future<void> validafim() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Clicar em "Sim" irá encerrar este formulário, enviar os dados aqui informados e retornar a tela inicial. \n\n '),
                Text('Tem certeza que deseja finalizar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                try {
                  concluiOS().concluir(os);
                } catch (e) {
                  syncoff().criarjson(os);
                }

                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaInicial()),
                );
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        title: Text('Coletar assinatura do responsável'),
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
                onPressed: () {
                  salvanocache();
                  syncoff().criarjson(os);
                  validafim();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
