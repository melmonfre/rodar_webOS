import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/deslocamento/variaveis_container_deslocamento.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

import '../../pages/check_out/tela_check_out.dart';

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
  var variaveis = VariaveisDeslocamento();
  String motivoDivergencia = '';
  double? disCalc;
  double? valor;
  double? pedagio;

  @override
  void initState() {
    super.initState();
    disCalc = null;
    valor = null;
    pedagio = null;
  }

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
                    InputText(
                      labelText: 'Distância calculada (KM)',
                      onChanged: (value) {
                        setState(() {
                          disCalc = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
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
                    InputText(
                      labelText: 'Latitude',
                      enabled: false,
                    ),
                    InputText(
                      labelText: 'Longitude',
                      enabled: false,
                    ),
                    InputText(
                      labelText: 'Valor (R\$)',
                      showInfoIcon: true,
                      onChanged: (value) {
                        setState(() {
                          valor = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    InputText(
                      labelText: 'Pedágio (R\$)',
                      onChanged: (value) {
                        setState(() {
                          pedagio = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 5.0),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16.0),
                        child: BotaoProximo(
                          onPressed: () {
                            if (disCalc != null &&
                                valor != null &&
                                pedagio != null) {
                              variaveis.disCalc = disCalc;
                              variaveis.valor = valor;
                              variaveis.pedagio = pedagio;
                              
                              widget.onPressed();
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Erro'),
                                    content: Text(
                                        'Por favor, preencha todos os campos obrigatórios.'),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),),
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
