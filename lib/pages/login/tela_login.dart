import 'dart:async';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:rodarwebos/pages/login/recuperar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rodarwebos/pages/login/recuperar.dart'
    as recuperar;

class login extends StatefulWidget {
  var token;
  login(this.token, {Key? key}) : super(key: key);

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
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
  Widget build(BuildContext context) {
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
      backgroundColor: Color(0xFF147C7B),
      body: Container(
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //   image: AssetImage('assets/login/background/background.jpg'),
          //   fit: BoxFit.cover,
          // )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: largura * .60,
                    height: altura * .30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/rekta/REKTALogotipo03.png'),
                      fit: BoxFit.contain,
                    )) 
                )
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: largura * .60,
                    height: altura * .50,
                    margin: EdgeInsets.all(altura *
                        0.018), // Adicionando uma margem para o container
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.7), // Definindo a cor do container

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
                              alignment: Alignment.centerLeft,
                              child: Text('Usuário',
                                  style: TextStyle(color: Color(0xFF00204E))),
                            ),
                            SizedBox(height: altura * 0.02),
                            TextField(
                              onChanged: (text) {
                                username = text;
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                enabled: islogged,
                                suffixIcon: Icon(Icons.person,
                                    color: Color(0xFF26738e)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: altura * 0.018,
                                    horizontal: largura * .016),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF00204E),
                                    width: largura * .002,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF00204E),
                                    width: largura * .002,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF00204E),
                              ),
                            ),
                            SizedBox(
                              height: altura * 0.02,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Senha',
                                  style: TextStyle(color: Color(0xFF00204E))),
                            ),
                            SizedBox(
                              height: altura * 0.02,
                            ),
                            TextField(
                              onChanged: (text) {
                                password = text;
                              },
                              textInputAction: TextInputAction.next,
                              obscureText: true,
                              decoration: InputDecoration(
                                enabled: islogged,
                                suffixIcon:
                                    Icon(Icons.key, color: Color(0xFF26738e)),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: altura * 0.008,
                                    horizontal: largura * 0.016),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide(
                                    color: Color(0xFF00204E),
                                    width: largura * .004,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF00204E),
                                    width: largura * .002,
                                  ),
                                ),
                              ),
                              style: TextStyle(
                                color: Color(0xFF00204E),
                              ),
                            ),
                            SizedBox(
                              height: altura * 0.018,
                            ),
                            ElevatedButton(
                              onPressed: isButtonEnabled
                                  ? () async => {
                                        setState(() {
                                          isButtonEnabled = false;
                                          // -------------------------- CHAMANDO O BOOLEAN
                                          islogged = false;
                                          isLoading = true;
                                        }),
                                        //ApiService().buscaAPI(username, password),
                                        // json = await obter.ApiService()
                                        // .buscaAPI(username, password),
                                        print("json $json"),
                                        if (json.toString().contains("timeout"))
                                          {
                                            islogged = true,
                                            isLoading = false,
                                            showPlatformDialog(
                                              context: context,
                                              builder: (_) => BasicDialogAlert(
                                                title: Text(
                                                    "Houve um erro na solicitação"),
                                                content: Text(
                                                    "Alcançado tempo limite da requisição, Tente Novamente"),
                                                actions: <Widget>[
                                                  BasicDialogAction(
                                                    title: Text("OK"),
                                                    onPressed: () {
                                                      setState(() {
                                                        isButtonEnabled = true;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          }
                                        else if (json
                                            .toString()
                                            .contains("Errorlogin"))
                                          {
                                            islogged = true,
                                            isLoading = false,
                                            showPlatformDialog(
                                              context: context,
                                              builder: (_) => BasicDialogAlert(
                                                title: Text(
                                                    "Houve um erro na solicitação"),
                                                content: Text(
                                                    "Login ou senha inválidos"),
                                                actions: <Widget>[
                                                  BasicDialogAction(
                                                    title: Text("OK"),
                                                    onPressed: () {
                                                      setState(() {
                                                        isButtonEnabled = true;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          }
                                        // else
                                        //   {
                                        //     gravadados(),
                                        //     Navigator.of(context).pop(),
                                        //     //quando clicado no botao o usuario deve ser direcionado para a outra pagina
                                        //     Navigator.push(
                                        //       context,
                                        //       //Navigator permite a navegação entre as paginas
                                        //       MaterialPageRoute(
                                        //           builder: (context) => Veiculo(
                                        //               json,
                                        //               username,
                                        //               password)),
                                        //     ),
                                        //     aut = await auth().buscaAPI(
                                        //         username, password, token),
                                        //     print("auth: $aut"),
                                        //   },
                                      }
                                  : null,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.login),
                                  SizedBox(width: largura * .005),
                                  Text(
                                    'Entrar',
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                            // -------------------------- ANIMACAO ---------------------
                            if (isLoading) // Verifica se está carregando
                              Container(
                                child: Center(
                                  child: LoadingAnimationWidget.flickr(
                                    leftDotColor: Color(0xFF26738e),
                                    rightDotColor: Color(0xFF00204E),
                                    size: 30,
                                  ),
                                ),
                              ),

                            SizedBox(height: altura * 0.004),
                            TextButton(
                              onPressed: () => {
                                Navigator.of(context).pop(),
                                //quando clicado no botao o usuario deve ser direcionado para a outra pagina
                                Navigator.push(
                                  context,
                                  //Navigator permite a navegação entre as paginas
                                  MaterialPageRoute(
                                      builder: (context) => recupera(token)),
                                ),
                              },
                              child: Text(
                                textRecover,
                                style: TextStyle(
                                  color: Color(0xFF00204E),
                                  fontSize: 14.0,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}