import 'dart:async';
import 'package:flutter_dialogs/flutter_dialogs.dart';

import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter/material.dart";
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../widgets/login/container_login.dart';
import '../../widgets/login/variaveis_login.dart';

class loginTeste extends StatefulWidget {
  var token;
  loginTeste(this.token, {Key? key}) : super(key: key);

  @override
  State<loginTeste> createState() => _loginTesteState();
}

class _loginTesteState extends State<loginTeste> {
  var variaveis = VarLogin();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF147C7B),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(30),
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
                CustomContainerWidget(
                  imagePath: variaveis.images[0],
                  name: variaveis.nomesEmpresas[0],
                  nextPage: TelaInicial(),
                ),

                // Outros widgets...
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
