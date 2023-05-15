import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/motivos/visita_frustada_motivos.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/deslocamento/container_deslocamento.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class VisitaFrustadaDeslocamento extends StatefulWidget {
  // final VoidCallback onPressed;

  // const VisitaFrustadaDeslocamento({required this.onPressed});

  @override
  _VisitaFrustadaDeslocamentoState createState() =>
      _VisitaFrustadaDeslocamentoState();
}

class _VisitaFrustadaDeslocamentoState
    extends State<VisitaFrustadaDeslocamento> {
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
        title: Text('Visita frustada'),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitaFrustadaMotivo(),
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