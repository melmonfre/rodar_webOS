import 'dart:async';
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/getToken.dart';
import 'package:rodarwebos/services/validatoken.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FullPageLoadingIndicator extends StatelessWidget {
  List<Color> colors;
  Indicator indicatorType;

  FullPageLoadingIndicator({super.key, required this.colors, required this.indicatorType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: SizedBox(
          width: 225,
          child: LoadingIndicator(
              indicatorType: indicatorType,
              colors: colors,
              strokeWidth: 4.0,
              backgroundColor: Colors.white,

              /// Optional, Background of the widget
              pathBackgroundColor: Colors.white

              /// Optional, the stroke backgroundColor
              ),
        ),
      ),
    );
  }
}

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

  var link = null;
  var texto = "ou faça a leitura do código QR";

  Future<void> validalink() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Link inválido, tente novamente'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> errtoken() async {
    setState(() {
      isLoadingTelaInicial = false;
    });
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Link de acesso expirado, favor entrar em contato com o suporte'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

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
                      hintText: link != null ? link : 'Informe o link'),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text) {
                    setState(() {
                      link = text;
                    });
                  },
                ),
                Text(
                  "$texto",
                  style: TextStyle(color: Colors.black54),
                ),
                IconButton(
                  iconSize: 72,
                  icon: const Icon(Icons.qr_code_rounded),
                  color: Color.fromARGB(255, 4, 30, 70),
                  onPressed: () async {
                    link = await scanner.scan();
                    setState(() {
                      link;
                      texto = "Link: " + link;
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
                if (isLoadingTelaInicial) return;

                setState(() {
                  isLoadingTelaInicial = true;
                });

                try {
                  var divid = link?.split("/auth/");
                  var token = divid?[1];
                  var valtoken = await validatoken().validar(token);
                  if (link == null || !link.toString().contains("siger.winksys.com.br")) {
                    validalink();
                  } else if (valtoken == true) {
                    errtoken();
                  } else {
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
                    // Navigator.of(context).pop();
                    _showSingleAnimationDialog(context, Indicator.ballSpinFadeLoader);
                    vaiprapaginainicial();
                  }
                } catch (e) {
                  debugPrint(e.toString());
                  isLoadingTelaInicial = false;
                  rethrow;
                }
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
    debugPrint("is loading tela inicial" + isLoadingTelaInicial.toString());
    Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: false,
            builder: (ctx) {
              return FullPageLoadingIndicator(
                colors: _kDefaultRainbowColors,
                indicatorType: indicator,
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
      Uint8List data = (await rootBundle.load('assets/bear.png')).buffer.asUint8List();
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
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingTelaInicial = false;
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaInicial()),
      );
    });
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

  bool isLoadingTelaInicial = false;

  @override
  Future<void> geturso() async {
    Uint8List data = (await rootBundle.load('assets/bear.png')).buffer.asUint8List();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        linkmanual();
                      },
                      backgroundColor: Color.fromARGB(255, 2, 107, 128),
                      child: const Icon(Icons.login_rounded),
                    ),
                  ],
                ),
                Container(
                  height: altura * .50,
                  margin: EdgeInsets.all(altura * 0.018), // Adicionando uma margem para o container
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
                            border: Border(top: BorderSide(color: Colors.black12)),
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
                              onTap: () async {
                                if (isLoadingTelaInicial) return;

                                setState(() {
                                  isLoadingTelaInicial = true;
                                });

                                error = await validatoken().validabearer(ids[index]);

                                if (error == false) {
                                  _showSingleAnimationDialog(context, Indicator.ballSpinFadeLoader);
                                  setsession(ids[index]);
                                  getToken().sincronizar(ids[index]);
                                  vaiprapaginainicial();
                                } else {
                                  errtoken();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                // gera a linha
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(25.0, 0.0, 22.0, 0.0),
                                    child: Image.memory(imagens[index], width: 60, height: 60),
                                  ),
                                  // const SizedBox(width: 10.0),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(padding: EdgeInsets.only(top: 7)),
                                      Text(
                                        '${Nomeempresa[index]}',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 2)),
                                      Text(
                                        '${nomes[index]}',
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Padding(padding: EdgeInsets.only(top: 5)),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
