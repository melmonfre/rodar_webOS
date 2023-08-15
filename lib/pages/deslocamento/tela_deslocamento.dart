import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_out/tela_check_out.dart';
import 'package:rodarwebos/services/conclusao/salvardeslocamento.dart';
import 'package:rodarwebos/widgets/deslocamento/container_deslocamento.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class TelaDeslocamento extends StatefulWidget {
  @override
  _TelaDeslocamentoState createState() => _TelaDeslocamentoState();
}

class _TelaDeslocamentoState extends State<TelaDeslocamento> {
  var variaveis = VariaveisResumo();

  String motivoDivergencia = '';

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
        title: Text('Deslocamento'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContainerDeslocamento(
                titulo: "Deslocamento",
                onPressed: () {
                  salvardeslocamento().enviar();
                  //Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckOutTela(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
