import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/equipamentos/variaveis_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerEquipamento extends StatefulWidget {
  @override
  _ContainerEquipamentoState createState() => _ContainerEquipamentoState();
}

class _ContainerEquipamentoState extends State<ContainerEquipamento> {
  String? situacaoEquipamento;
  String localInstalacao = '';

  var variaveis = VariaveisEquipamentos();


  @override
  void initState() {
    super.initState();
    situacaoEquipamento = null;
  }

  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();

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
                'Instalação',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              DropdownButton<int>(
                value: variaveis.selectedListItem,
                onChanged: (int? newValue) {
                  setState(() {
                    variaveis.selectedListItem = newValue;
                  });
                },
                items: codigosEq.map((int item) {
                  return DropdownMenuItem<int>(
                    value: item,
                    child: Row(
                      children: [
                        Icon(Icons.arrow_right),
                        SizedBox(width: 5.0),
                        Text(item.toString()),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16.0),
              Text(
                'Situação do equipamento',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text(
                      'OK',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'OK',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Com defeito',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'Com defeito',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Local de instalação',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                decoration: InputDecoration(
                  // labelText: 'Local de instalação...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    localInstalacao = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              BotaoProximo(
                onPressed: () {
                  if (situacaoEquipamento != null &&
                      localInstalacao.isNotEmpty) {
                    variaveis.situacaoEquipamento = situacaoEquipamento!;
                    variaveis.localInstalacao = localInstalacao;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acessorios()),
                    );
                  } else {
                    // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Erro'),
                          content:
                              Text('Por favor, preencha todas as respostas.'),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
