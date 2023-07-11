import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/getToken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../widgets/login/container_login.dart';

class login extends StatefulWidget {
  var token;
  login(this.token, {Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  List<Color> _kDefaultRainbowColors = const [
    Color.fromARGB(255, 0, 185, 181),
    Color.fromARGB(255, 0, 168, 166),
    Color.fromARGB(255, 0, 141, 157),
    Color.fromARGB(255, 2, 107, 128),
    Color.fromARGB(255, 3, 91, 117),
    Color.fromARGB(255, 3, 66, 98),
    Color.fromARGB(255, 4, 30, 70),
  ];

  var link;

  Future<void> linkmanual() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inserir Link Manualmente'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Icon(Icons.link),
                      hintText: 'Informe o link'),
                  onChanged: (text) {
                    setState(() {
                      link = text;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('concluir'),
              onPressed: () async {
                Navigator.of(context).pop();
                _showSingleAnimationDialog(
                    context, Indicator.ballSpinFadeLoader);
                var linkExterno;
                String? initialLink = link;
                if (initialLink != null || initialLink != "") {
                  linkExterno = initialLink;
                  if (linkExterno != null || linkExterno != "") {
                    var divid = linkExterno?.split("/auth/");
                    print(divid);
                    var token = divid?[1];
                    print('Link externo: $linkExterno');
                    print('token $token');
                    await getToken().obter(token);
                  }
                }
                vaiprapaginainicial();
              },
            ),
          ],
        );
      },
    );
  }

  getToken tokenInstance = getToken(); //instanciando a classe getToken
  static const Utf8Codec utf8 = Utf8Codec();
  List nomes = [];
  List ids = [];
  List imagens = [];
  var urso;
  List Nomeempresa = [];
  bool error = false;
  _showSingleAnimationDialog(BuildContext context, Indicator indicator) {
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: false,
            builder: (ctx) {
              return LoadingIndicator(
                  indicatorType: indicator,
                  colors: _kDefaultRainbowColors,
                  strokeWidth: 4.0,
                  backgroundColor: Colors.white,

                  /// Optional, Background of the widget
                  pathBackgroundColor: Colors.white

                  /// Optional, the stroke backgroundColor
                  );
            }));
  }

  preenchelogin() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var emps;
    try {
      emps = opcs.getStringList("empresas");
      if (emps == null) {
        error = true;
      }
      print("EMPS: $emps");
    } catch (e) {
      error = true;
    }

    if (error == true) {
      ids.add(0);
      Nomeempresa.add("ERRO");
      nomes.add(
          "Não há nenhuma empresa \ncadastrada, favor acessar pelo \nlink enviado pelo sistema");
      Uint8List data =
          (await rootBundle.load('assets/bear.png')).buffer.asUint8List();
      setState(() => imagens.add(data));
    }
    print('ERROR $error');

    for (var i = 0; i < emps.length; i++) {
      var emp = jsonDecode(emps[i]);
      print(emp);

      ids.add(emp['id']);
      print(emp['id']);
      //Nomeempresa.add(elemento['nome']);
    }

    for (var i = 0; i < emps.length; i++) {
      var log = jsonDecode(await getToken().getlogin(ids[i]));
      print(log);
      nomes.add(log['nome']);
      try {
        imagens.add(const Base64Decoder().convert(log['logo']));
      } catch (e) {
        var imbase64 = log['logo'].split(',');

        imagens.add(base64Decode(imbase64[1]));
      }

      var empresas = log['empresa'];
      Nomeempresa.add(empresas["nome"]);
    }
  }

  Future<void> setsession(id) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setInt("sessionid", id);
  }

  vaiprapaginainicial() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaInicial()),
    );
  }

  bool isButtonEnabled = true;
  var username;
  var password;
  var json;
  var textRecover = "Recuperar Senha";
  var aut;
  var altura;
  var largura;
  bool islogged = true;

  bool isLoading = false;
  @override
  Future<void> geturso() async {
    Uint8List data =
        (await rootBundle.load('assets/bear.png')).buffer.asUint8List();
    setState(() => urso = data);
  }

  void initState() {
    geturso();
    setState(() {
      preenchelogin();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int tamanho = ids.length;
    var token = widget.token;
    altura = MediaQuery.of(context).size.height;
    largura = MediaQuery.of(context).size.width;
    if (altura > largura) {
      setState(() {
        altura = MediaQuery.of(context).size.height;
        largura = MediaQuery.of(context).size.width * 1.4;
      });
    } else {
      setState(() {
        largura = MediaQuery.of(context).size.height;
        altura = MediaQuery.of(context).size.height;
      });
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF147C7B),
        
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  width: largura * .60,
                  height: altura * .30,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/rekta/REKTALogotipo03.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: altura * .50,
                  margin: EdgeInsets.all(altura *
                      0.018), // Adicionando uma margem para o container
                  decoration: BoxDecoration(
                    //color: Colors.transparent,
                    //.withOpacity(0.7), // Definindo a cor do container

                    boxShadow: [
                      BoxShadow(
                        color: Colors.transparent,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(
                          0,
                          largura * .002,
                        ),
                      ),
                    ],
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: tamanho,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: const EdgeInsets.only(top: 5),
                          decoration: const BoxDecoration(
                            border: Border(
                                top: BorderSide(color: Colors.black12)),
                          ),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //color: Colors.transparent,
                              //.withOpacity(0.7), // Definindo a cor do container
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                if (error == false) {
                                  print("tap");
                                  _showSingleAnimationDialog(
                                      context, Indicator.ballSpinFadeLoader);
                                  setsession(ids[index]);
                                  getToken().sincronizar(ids[index]);
                                  vaiprapaginainicial();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // gera a linha
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        25.0, 0.0, 22.0, 0.0),
                                    child: Image.memory(imagens[index],
                                        width: 60, height: 60),
                                  ),
                                  // const SizedBox(width: 10.0),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(top: 7)),
                                      Text(
                                        '${Nomeempresa[index]}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 2)),
                                      Text(
                                        '${nomes[index]}',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(top: 5)),
                                      // TextButton(
                                      //   style: ButtonStyle(
                                      //     foregroundColor:
                                      //         MaterialStateProperty.all<
                                      //             Color>(Colors.blue),
                                      //   ),
                                      //   onPressed: () {
                                      //     linkmanual();
                                      //   },
                                      //   child:
                                      //       Text('Inserir link manualmente'),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // botao flutuante
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 0,
                      right: 16), 
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        linkmanual();
                      },
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.link),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
