import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class ContainerConclusao extends StatefulWidget {
  // final String titulo;
  final VoidCallback onPressed;

  const ContainerConclusao({
    // required this.titulo,
    required this.onPressed,
  });

  @override
  _ContainerConclusaoState createState() => _ContainerConclusaoState();
}

class _ContainerConclusaoState extends State<ContainerConclusao> {
  var variaveis = VariaveisResumo();
  String motivoDivergencia = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   alignment: Alignment.center,

              // ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 14.0,
                    ),
                    InputText(labelText: 'Data de conclusão da OS'),
                    InputText(labelText: 'Observações'),
                    InputText(labelText: 'Hodômetro'),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: BotaoProximo(
                        onPressed: widget.onPressed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
