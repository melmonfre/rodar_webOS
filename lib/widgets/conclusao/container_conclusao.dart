import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerConclusao extends StatefulWidget {
  final VoidCallback onPressed;

  const ContainerConclusao({
    required this.onPressed,
  });

  @override
  _ContainerConclusaoState createState() => _ContainerConclusaoState();
}

class _ContainerConclusaoState extends State<ContainerConclusao> {
  var variaveis = VariaveisResumo();
  String motivoDivergencia = '';

  String dataConclusao = '';
  String observacoes = '';
  String hodometro = '';

  bool validateInputs() {
    if (dataConclusao.isEmpty || observacoes.isEmpty || hodometro.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Text('Por favor, preencha todos os campos antes de prosseguir.'),
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
      return false;
    } else{
      Map<String, dynamic> values = {
        "dataConclusao" : dataConclusao,
        "observacoes" : observacoes,
        "hodometro" : hodometro,
      };
      saveoncache(json.encode(values));
      return true;
    }
  }
  Future<void> saveoncache(valor) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("conclusaoItens", valor);
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
                    InputText(
                      labelText: 'Data de conclusão da OS',
                      onChanged: (value) {
                        setState(() {
                          dataConclusao = value;
                        });
                      },
                    ),
                    InputText(
                      labelText: 'Observações',
                      onChanged: (value) {
                        setState(() {
                          observacoes = value;
                        });
                      },
                    ),
                    InputText(
                      labelText: 'Hodômetro',
                      onChanged: (value) {
                        setState(() {
                          hodometro = value;
                        });
                      },
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: BotaoProximo(
                        onPressed: () {
                          if (validateInputs()) {
                            widget.onPressed();
                          }
                        },
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
