import "package:flutter/material.dart";
// import 'package:ordemservicoproject/pages/recuperar_senha/login.dart;
// import 'package:rodar_mobile/services/enviacodigo.dart';
import 'dart:async';

import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:rodarwebos/pages/login/recuperar.dart'
    as recuperar;

class codigo extends StatefulWidget {
  static var username;
  static var token;

  const codigo(username, token, {Key? key}) : super(key: key);
  @override
  State<codigo> createState() => _codigoState();
}

class _codigoState extends State<codigo> {
  var username = codigo.username;
  var token = codigo.token;
  var usercode;
  var code;
  var json;
  var textRecover = "Informar Código";
  var icon = Icons.key;
  var timer = 30;
  var senhanova;
  var altura;
  var largura;
  bool isempty = false;
  @override
  void initState() {
    _decrementCounter();
    super.initState();
  }

  void _decrementCounter() {
    Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        timer--;
        if (timer == 0) {
          isempty = true;
        }
      });
    });
  }

  build(BuildContext context) {
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
    return Scaffold(
        backgroundColor: Color(0xFF147C7B),
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/login/background/background.jpg'),
              fit: BoxFit.cover,
            )),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: largura * .60,
                    height: altura * .30,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/rekta/REKTALogotipo03.png'),
                      fit: BoxFit.contain,
                    )))
              ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: largura * .60,
                    height: altura * .60,
                    margin: EdgeInsets.all(altura * 0.028),
                    // Adicionando uma margem para o container
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      // Definindo a cor do container

                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
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
                    child: Center(
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.all(
                              altura * 0.016,
                            ),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 0, 0, altura * 0.016),
                                      child:
                                          Text('Enviamos um código para você',
                                              style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 25,
                                              )),
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0, 0, 0, altura * 0.016),
                                        child: Text(
                                            'Confira seu email para pegar o código de confirmação. Caso não tenha recebido solicite um novo envio',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17,
                                            )),
                                      )),
                                  SizedBox(height: 8.0),
                                  Column(
                                    children: [
                                      Text("Insira o código"),
                                      SizedBox(height: 8.0),
                                      TextField(
                                        onChanged: (text) {
                                          usercode = text;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.vpn_key,
                                              color: Color(0xFF00204E)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: Color(0xFF00204E),
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF00204E),
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Color(0xFF00204E),
                                        ),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text("Nova senha"),
                                      SizedBox(height: 8.0),
                                      TextField(
                                        onChanged: (text) {
                                          senhanova = text;
                                        },
                                        decoration: InputDecoration(
                                          suffixIcon: Icon(Icons.lock,
                                              color: Color(0xFF00204E)),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            borderSide: BorderSide(
                                              color: Color(0xFF00204E),
                                              width: 2.0,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color(0xFF00204E),
                                              width: 2.0,
                                            ),
                                          ),
                                        ),
                                        style: TextStyle(
                                          color: Color(0xFF00204E),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                                    child: ElevatedButton(
                                      onPressed: () async => {
                                        // json = await enviacod().postApi(
                                        //     username, usercode, senhanova),
                                        // print("json $json"),
                                        if (json.toString().contains("Error"))
                                          {
                                            showPlatformDialog(
                                              context: context,
                                              builder: (_) => BasicDialogAlert(
                                                title: Text(
                                                    "Houve um erro na solicitação"),
                                                content: Text(
                                                    "Usuário Não encontrado"),
                                                actions: <Widget>[
                                                  BasicDialogAction(
                                                    title: Text("OK"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                            // Alert(
                                            //   context: context,
                                            //   title: "Houve um erro na solicitação",
                                            //   desc: "Usuário Não encontrado",

                                            // ).show()
                                            //TODO ALERT TO POPUP
                                          }
                                        else
                                          {
                                            print("TODO"),
                                            // Navigator.push(
                                            //   context
                                            //   //Navigator permite a navegação entre as paginas
                                            //   // MaterialPageRoute(
                                            //   //     // builder: (context) =>
                                            //   //     //     login(token)),
                                              
                                            // ),

                                            //quando clicado no botao o usuario deve ser direcionado para a outra pagina
                                            // Navigator.push(context,
                                            //Navigator permite a navegação entre as paginas
                                            //MaterialPageRoute(builder: (context) => Veiculo(json)),
                                            //),
                                          },
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login),
                                          SizedBox(width: 5),
                                          Text(
                                            'Enviar',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.0,
                                            ),
                                          ),
                                          Opacity(
                                            opacity: 0,
                                            child: Icon(Icons.key),
                                          ),
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color(0xFF00204E), // Cor do botão
                                        minimumSize: Size(50, 46),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: isempty
                                        ? () async => {
                                              setState(() {
                                                timer = 30;
                                                isempty = false;
                                              }),

                                              // json =
                                              //     await recuperar.ApiService()
                                              //         .buscaSenha(username),
                                              // print("json $json"),
                                              // if (json
                                              //     .toString()
                                              //     .contains("Error"))
                                                {
                                                  // Alert(
                                                  //   context: context,
                                                  //   title: "Houve um erro na solicitação",
                                                  //   desc: "Usuário Não encontrado",

                                                  // ).show()  TODO ALERT TO POPUP
                                                },
                                              //quando clicado no botao o usuario deve ser direcionado para a outra pagina
                                              //Navigator permite a navegação entre as paginas
                                              //MaterialPageRoute(builder: (context) => recupera()),
                                              print("TESTE")
                                            }
                                        : null,
                                    child: Text(
                                      isempty
                                          ? "Não recebi o código"
                                          : "Aguarde $timer segundos",
                                      style: TextStyle(
                                        color: isempty
                                            ? Color(0xFF00204E)
                                            : Colors.grey,
                                        fontSize: 14.0,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ]))))
              ])
            ])));
  }
}