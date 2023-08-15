import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/widgets/anexos/anexo_evidencias.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/salvaFotos.dart';

class FotoHodometro extends StatefulWidget {
  @override
  _FotoHodometroState createState() => _FotoHodometroState();
}

class _FotoHodometroState extends State<FotoHodometro> {
  List<String> referencias = []; // Adicione uma lista de referências
  String referenciaatual = "";
  int indiceatual = 0;
  int referenciaIndex = 0; // Índice da referência atua
  var osid;
  var refatu;
  click() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    setState(() {
      try {
        salvarfotos().save("${referencias[indiceatual]}");
        print("Foto ${referencias[refatu]} salva");
      } catch (e) {}
    });
    setState(() {
      indiceatual = indiceatual + 1;
    });
    print("INDICEATUAL $indiceatual");
    if (indiceatual >= referencias.length) {
      //Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDeslocamento(),
        ),
      );
      setState(() {
        referenciaatual = referencias[indiceatual];
        refatu = referencias[indiceatual];
      });
      opcs.setString('referenciaatual', referenciaatual);
      opcs.setInt('indiceatual', indiceatual);
    } else {
      opcs.setString('referenciaatual', referenciaatual);
      opcs.setInt('indiceatual', indiceatual);
      setState(() {
        referenciaatual = referencias[indiceatual];
      });
      proximaTela();
    }
  }

  Future<void> proximaTela() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    print("REFERENCIAS $referencias");
    print("REFERENCIA ATUAL $referenciaatual");
    if (indiceatual > referencias.length - 1) {
      indiceatual = 0;
      refatu = referencias[indiceatual];
    }
    referenciaIndex = indiceatual;

    print("REF ATUAL " + referenciaatual);

    if (referenciaIndex < referencias.length) {
      // se ainda não estiver no fim das referencias volta para a tela de fotos do hodometro
      try {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FotoHodometro(),
          ),
        );
      } catch (e) {}
    } else {
      opcs.setString('referenciaatual', referencias[0]);
      indiceatual = 0;
      // Última tela, redirecione para a próxima página
      //Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDeslocamento(),
        ),
      );
    }
  }

  fotoinicial() {
    setState(() {
      referenciaIndex = indiceatual;
    });
  }

  getdata() async {
    var json;
    var element;

    SharedPreferences opcs = await SharedPreferences.getInstance();

    setState(() {
      referencias = opcs.getStringList("referencias")!;
    });
    print("REFS $referencias");
    print("INDICEATUAL $indiceatual");
    print("REFERENCIA ATUAL ${referencias[indiceatual]}");
    setState(() {
      if (opcs.containsKey('indiceatual')) {
        indiceatual = opcs.getInt('indiceatual')!;
        try {
          referenciaatual = opcs.getString('referenciaatual')!;
        } catch (e) {
          referenciaatual = referencias[indiceatual];
        }
      }
      refatu = referencias[indiceatual];
    });

    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    osid = element['id'];
  }

  @override
  void initState() {
    getdata();
    fotoinicial();
    super.initState();
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
        title: Text('Fotos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$osid",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildTelaReferencia(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTelaReferencia() {
    if (referencias.isNotEmpty && referenciaIndex < referencias.length) {
      return Column(
        children: [
          SizedBox(height: 16.0),
          AnexoEvidencias(
            titulo: "$refatu",
            onPressed: click,
          ),
        ],
      );
    } else {
      // Sem referências, retorne a tela original
      return AnexoEvidencias(
        titulo: '  ',
        onPressed: click,
      );
    }
  }
}
