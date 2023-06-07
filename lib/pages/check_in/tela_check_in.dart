import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_in/variaveis_options.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/check_in/container_check_in.dart';
import 'package:rodarwebos/widgets/check_in/container_observacao_adicional.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInTela extends StatefulWidget {
  @override
  _CheckInTelaState createState() => _CheckInTelaState();
}

class _CheckInTelaState extends State<CheckInTela> {
  SelectedOptions selectedOptions =
      SelectedOptions(); // Instância da classe SelectedOptions
  List checklistID =[];
  List checklistNome = [];
  List checklistItens = [];
  Future<void> getdata() async {
    var json;
    var osid;
    var element;
    var empresaid;
    var token;
    var check;
    List checklist = [];
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    empresaid = opcs.getInt('sessionid');
    element = jsonDecode(json);
    token = opcs.getString("${empresaid}@token")!;
    osid = element['id'];
    check = opcs.getString("${osid}@checklist");
    checklist = jsonDecode(check);
    checklist.forEach((element) { 
      checklistID.add(element['id']);
      checklistNome.add(element['descricao']);
    });
  }
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
        title: Text('Check-in'),
      ),
      body:  ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: checklistID.length,
          itemBuilder: (BuildContext context, int index)
          {
            return Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    ContainerCheckIn(
                      title: '${checklistNome[index]}',
                      onOptionSelected: (option) {
                        setState(() {
                          if(checklistItens.asMap().containsKey(index)){
                            checklistItens[index] = option;
                          } else {
                            checklistItens.add(option); // Atualize o valor selecionado
                          }

                        });
                      },
                    ),
                    ContainerObservacaoAdicional(
                      onPressed: () {
                        checkNavigation();

                      },
                    ),

                  ],
                ),
              ],
            );
          }


      ),
    );
  }
  void checkNavigation() {

    if (checklistItens.length != checklistID.length) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Text(
                'Por favor, preencha todas as opções antes de prosseguir.'),
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Equipamentos()),
      );
    }
  }
}


