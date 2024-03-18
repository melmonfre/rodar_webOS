import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_date.dart';
import 'package:rodarwebos/widgets/inputs/input_number.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/conclusao/conclusao.dart';

class ContainerConclusao extends ConsumerStatefulWidget {
  final VoidCallback onPressed;

  const ContainerConclusao({
    required this.onPressed,
  });

  @override
  _ContainerConclusaoState createState() => _ContainerConclusaoState();
}

class _ContainerConclusaoState extends ConsumerState<ContainerConclusao> {
  var variaveis = VariaveisResumo();
  String motivoDivergencia = '';

  String dataConclusao =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  String observacoes = '';
  String hodometro = '';

  bool validateInputs() {
    if (dataConclusao.isEmpty || observacoes.isEmpty || hodometro.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Text(
                'Por favor, preencha todos os campos antes de prosseguir.'),
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
    } else {
      saveoncache();
      // enviaconclusao().enviar();
      return true;
    }
  }

  Future<void> saveoncache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    Map<String, dynamic> values = {
      "dataConclusao": dataConclusao,
      "observacoes": observacoes,
      "hodometro": hodometro,
    };
    var valor = json.encode(values);
    await opcs.setString(buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.CONCLUSAO.key), valor);
    await opcs.setString("conclusaoItens", valor);
    
    ref.read(selectedOsProvider).updateEtapasState();
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
                    InputDate(
                      labelText: 'Data de conclusão da OS',
                    ),
                    InputText(
                      labelText: 'Observações',
                      onChanged: (value) {
                        setState(() {
                          print("$value");
                          observacoes = value;
                        });
                      },
                    ),
                    InputNumber(
                      labelText: 'Hodômetro',
                      onChanged: (value) {
                        setState(() {
                          print("$value");
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
                          saveoncache();
                          // if (validateInputs()) {
                          widget.onPressed();
                          // }
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
