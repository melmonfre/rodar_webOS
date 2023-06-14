import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerObservacaoAdicional extends StatefulWidget {
  final void Function() onPressed;

  const ContainerObservacaoAdicional({required this.onPressed});

  @override
  _ContainerObservacaoAdicionalState createState() =>
      _ContainerObservacaoAdicionalState();
}

class _ContainerObservacaoAdicionalState
    extends State<ContainerObservacaoAdicional> {
  String selectedButton = '';
  TextEditingController observacaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Possui alguma observação adicional?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                        'Sim',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: 'Sim',
                      groupValue: selectedButton,
                      onChanged: (value) {
                        setState(() {
                          selectedButton = value.toString();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                        'Não Possui',
                        style: TextStyle(fontSize: 14.0),
                      ),
                      value: 'Não Possui',
                      groupValue: selectedButton,
                      onChanged: (value) {
                        setState(() {
                          selectedButton = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: observacaoController,
                decoration: InputDecoration(
                  labelText: 'Observação...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value){
                  obscheckin(value);
                },

              ),
              SizedBox(height: 16.0),
              BotaoProximo(
                onPressed: () {
                  if (selectedButton.isNotEmpty) {
                    // Os campos estão preenchidos, chama a função onPressed
                    widget.onPressed();
                  } else {
                    // Exibe um diálogo de alerta ao usuário
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Campos não preenchidos'),
                          content: Text('Por favor, preencha todos os campos de observação adicional.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Fechar'),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> obscheckin(String value) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("obscheckin", value);
  }
}
