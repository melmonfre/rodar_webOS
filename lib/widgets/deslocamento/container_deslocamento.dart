import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class ContainerDeslocamento extends StatefulWidget {
  final String titulo;
  final VoidCallback onPressed;

  const ContainerDeslocamento({
    required this.titulo,
    required this.onPressed,
  });

  @override
  _ContainerDeslocamentoState createState() => _ContainerDeslocamentoState();
}

class _ContainerDeslocamentoState extends State<ContainerDeslocamento> {
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
              Container(
                alignment: Alignment.center,
                child: Text(
                  variaveis.numero_os.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
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
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        widget.titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InputText(labelText: 'Distância calculada (KM)'),
                    InputText(
                      labelText:
                          'Informe caso a distância seja divergente (KM)',
                      onChanged: (value) {
                        setState(() {
                          motivoDivergencia = value;
                        });
                      },
                    ),
                    if (motivoDivergencia.isNotEmpty) SizedBox(height: 3.0),
                    if (motivoDivergencia.isNotEmpty)
                      InputMotivos(
                        labelText:
                            'Qual o motivo da diferença de deslocamento?',
                        onChanged: (value) {
                          setState(() {
                            // Aqui você pode salvar o valor do motivo de alguma forma
                          });
                        },
                      ),
                    InputText(labelText: 'Latitude'),
                    InputText(labelText: 'Longitude'),
                    InputText(
                      labelText: 'Valor (R\$)',
                      showInfoIcon: true,
                    ),
                    InputText(labelText: 'Pedágio (R\$)'),
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
