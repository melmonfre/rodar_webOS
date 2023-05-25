import "package:flutter/material.dart";
import 'package:rodarwebos/pages/login/recuperar.dart'
    as recuperar;
import 'package:rodarwebos/pages/login/codigo.dart';

import 'package:flutter_dialogs/flutter_dialogs.dart';

class recupera extends StatefulWidget {
  var token;
  recupera(this.token, {Key? key}) : super(key: key);

  @override
  State<recupera> createState() => _recuperaState();
}

class _recuperaState extends State<recupera> {
  var username;
  var code;
  var json;
  var textRecover = "Recuperar Senha";
  var usercode = "Informe o seu nome de Usuário";
  var icon = Icons.person;

  var altura;
  var largura;
  @override
  build(BuildContext context) {
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

    return Scaffold(
        backgroundColor: Color(0xFF00204E),
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
                    height: altura * .50,
                    margin: EdgeInsets.all(altura * 0.018),
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
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 0, 0, altura * 0.016),
                                      child: Text('Recupere seu acesso',
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
                                            'Informe o email ou nome de usuário associado a sua conta para poder recuperar sua senha',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 17,
                                            )),
                                      )),
                                  SizedBox(height: 8.0),
                                  TextField(
                                    onChanged: (text) {
                                      username = text;
                                    },
                                    decoration: InputDecoration(
                                      suffixIcon:
                                          Icon(icon, color: Color(0xFF00204E)), // icon alterar cor
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: altura * 0.01,
                                          horizontal: largura * .0016),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        borderSide: BorderSide(
                                          color: Color(0xFF00204E),
                                          width: largura * 0.002,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color(0xFF00204E),
                                          width: largura * 0.002,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Color(0xFF00204E),
                                    ),
                                  ),
                                  SizedBox(
                                    height: altura * 0.016,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, altura * 0.01, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () async => {
                                        //ApiService().buscaAPI(username, password),
                                        // json = await recuperar.ApiService()
                                        //     .buscaSenha(username),
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
                                          }
                                        else
                                          {
                                            //quando clicado no botao o usuario deve ser direcionado para a outra pagina
                                            Navigator.push(
                                              context,
                                              //Navigator permite a navegação entre as paginas
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      codigo(username,token)),
                                            ),

                                            print("TODO")
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
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(Icons.login),
                                          SizedBox(width: altura * 0.006),
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
                                  SizedBox(height: altura * 0.016),
                                  ElevatedButton(
                                    // Botão "Cancelar"
                                    onPressed: () {
                                      // Navigator.push(
                                      //   context,
                                      //   //Navigator permite a navegação entre as paginas
                                      //   MaterialPageRoute(
                                      //       builder: (context) => login(token)),
                                      // );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.cancel),
                                        SizedBox(width: 5),
                                        Text(
                                          'Cancelar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      minimumSize: Size(50, 46),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  )
                                ]))))
              ])
            ])));
  }
}