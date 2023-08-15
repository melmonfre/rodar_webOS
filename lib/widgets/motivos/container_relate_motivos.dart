import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/conclusao/tela_conclusao.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/OS/GetMotivosOS.dart';

class ContainerRelateMotivos extends StatefulWidget {
  @override
  _ContainerRelateMotivosState createState() => _ContainerRelateMotivosState();
}

class _ContainerRelateMotivosState extends State<ContainerRelateMotivos> {
  List<bool> motivosbool = [];
  int tamanho = 0;
  List motivosnome = [];
  List motivosID = [];

  var json;
  var osid;
  var element;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    osid = element['id'];
    var empresaid = opcs.getInt("sessionid");
    var mot = opcs.getString("${osid}@motivos");
    if (mot == null) {
      mot = await GetMotivosOS().obter(empresaid, osid);
      opcs.setString("${osid}@motivos", mot!);
    }
    print(mot);
    List motivos = jsonDecode(mot!);
    motivos.forEach((m) {
      setState(() {
        motivosID.add(m["id"]);
        motivosnome.add(m["descricao"]);
        motivosbool.add(false);
        tamanho++;
        print("MOTIVOS: $motivosnome");
      });
    });
  }

  _hasSelectedCheckbox() {
    int count = 0;
    motivosbool.forEach((element) {
      if (element) {
        count++;
      }
    });
    if (count > 0) {
      return true;
    } else {
      return false;
    }
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
              backgroundColor: Colors.white,
              title: Text(
                '       OS $osid \n Relate os motivos',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
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
                                  child: Row(children: <Widget>[
                                    SizedBox(height: 5.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: motivosbool[index],
                                              onChanged: (newValue) {
                                                setState(() {
                                                  motivosbool[index] =
                                                      newValue ?? false;
                                                });
                                              },
                                              activeColor: Colors.blue[400],
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0)),
                                              visualDensity:
                                                  VisualDensity.compact,
                                            ),
                                            Text(
                                              "${motivosnome[index]}",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ]),
                                )
                              ],
                            );
                          } else {
                            return BotaoProximo(
                              onPressed: () {
                                Map<String, dynamic> values = {
                                  "idsmotivos": motivosID,
                                  "nomesmotivos": motivosnome,
                                  "itensmotivos": motivosbool,
                                };
                                saveoncache(jsonEncode(values));
                                if (!_hasSelectedCheckbox()) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Aviso'),
                                          content: Text(
                                              'Selecione pelo menos um motivo antes de prosseguir'),
                                          actions: [
                                            TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                })
                                          ],
                                        );
                                      });
                                } else {
                                  //Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TelaConclusao()),
                                  );
                                }
                              },
                            );
                          }
                        }))
              ],
            )));
  }

  Future<void> saveoncache(valor) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("motivositens", valor);
  }
}
