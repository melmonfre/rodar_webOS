import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/motivos/tela_relate_motivos.dart';
import 'package:rodarwebos/services/conclusao/checkout.dart';
import 'package:rodarwebos/widgets/check_in/container_observacao_adicional.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/GetEquipamento.dart';

class CheckOutTela extends StatefulWidget {
  @override
  _CheckOutTelaState createState() => _CheckOutTelaState();
}

class _CheckOutTelaState extends State<CheckOutTela> {
  List checklistID = [];
  List checklistNome = [];
  List checklistItens = [];
  List ChecklistOBS = [];
  List checkinsitu = [];
  int tamanho = 0;
  Future<void> getdata() async {
    var json;
    var osid;
    var element;
    var empresaid;
    var token;
    var check;

    List checklist = [];
    SharedPreferences opcs = await SharedPreferences.getInstance();
    getequipamentos().get();
    json = opcs.getString("SelectedOS");
    empresaid = opcs.getInt('sessionid');
    var checkin = opcs.getString('checkinitens');
    var checkinitens = jsonDecode(checkin!);
    List itenscheckin = checkinitens['itenscheckin'];
    itenscheckin.forEach((element) {
      if (element == 0) {
        checkinsitu.add("OK");
      } else if (element == 1) {
        checkinsitu.add("Com Defeito");
      } else if (element == 2) {
        checkinsitu.add("Não Possui");
      }
    });
    element = jsonDecode(json);
    token = opcs.getString("${empresaid}@token")!;
    osid = element['id'];
    check = opcs.getString("${osid}@checklist");
    checklist = jsonDecode(check);
    checklist.forEach((element) {
      setState(() {
        checklistID.add(element['id']);
        checklistNome.add(element['descricao']);
        ChecklistOBS.add("");
        checklistItens.add(3);
        tamanho = checklistID.length;
      });
    });
  }

  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Check-out'),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: tamanho + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index < tamanho) {
                            return Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(16.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width - 48,
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
                                      children: <Widget>[
                                        Text(
                                          "${checklistNome[index]}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(padding: EdgeInsets.all(4)),
                                        Text(
                                          "Situação no Check-in: ${checkinsitu[index]}",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(height: 5.0),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Radio(
                                                  value: 0,
                                                  groupValue:
                                                      checklistItens[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (checklistItens
                                                          .asMap()
                                                          .containsKey(index)) {
                                                        checklistItens[index] =
                                                            value;
                                                      } else {
                                                        checklistItens.add(
                                                            value); // Atualize o valor selecionado
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'OK',
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                                SizedBox(width: 13),
                                                Radio(
                                                  value: 1,
                                                  groupValue:
                                                      checklistItens[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (checklistItens
                                                          .asMap()
                                                          .containsKey(index)) {
                                                        checklistItens[index] =
                                                            value;
                                                      } else {
                                                        checklistItens.add(
                                                            value); // Atualize o valor selecionado
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Com \nDefeito',
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                                SizedBox(width: 13),
                                                Radio(
                                                  value: 2,
                                                  groupValue:
                                                      checklistItens[index],
                                                  onChanged: (value) {
                                                    setState(() {
                                                      if (checklistItens
                                                          .asMap()
                                                          .containsKey(index)) {
                                                        checklistItens[index] =
                                                            value;
                                                      } else {
                                                        checklistItens.add(
                                                            value); // Atualize o valor selecionado
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  'Não \nPossui',
                                                  style:
                                                      TextStyle(fontSize: 14.0),
                                                ),
                                              ],
                                            ),
                                            TextField(
                                              decoration: InputDecoration(
                                                labelText: 'Observação...',
                                                border: OutlineInputBorder(),
                                              ),
                                              onChanged: (value) {
                                                ChecklistOBS[index] = value;
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16.0),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return ContainerObservacaoAdicional(
                              onPressed: () {
                                Map<String, dynamic> values = {
                                  "idscheckin": checklistID,
                                  "nomescheckin": checklistNome,
                                  "itenscheckin": checklistItens,
                                  "obscheckin": ChecklistOBS
                                };

                                checkNavigation(json.encode(values));
                              },
                            );
                          }
                        }))
              ],
            )));
  }

  Future<void> checkNavigation(jsoncheckin) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    enviacheckout().enviar();

    bool error = false;
    for (int i = 0; i < checklistItens.length; i++) {
      if (checklistItens[i] == 3) {
        error = true;
      }
    }
    if (error) {
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
      opcs.setString("checkoutitens", jsoncheckin);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RelateMotivo()),
      );
    }
  }
}

// =============================================================
