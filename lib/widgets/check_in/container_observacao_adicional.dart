import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';

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
                decoration: InputDecoration(
                  labelText: 'Observação...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              BotaoProximo(
                onPressed: widget.onPressed,
              )
            ],
          ),
        ),
      ),
    );
  }
}