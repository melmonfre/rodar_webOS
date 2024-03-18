import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_in/tela_check_in.dart';
import 'package:rodarwebos/pages/os_em_execucao.dart';
import 'package:rodarwebos/services/OS/ServicoIniciado.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/OS/GetChecklistOS.dart';

class BotaoIniciarExecucaoServico extends StatefulWidget {
  @override
  _BotaoIniciarExecucaoServicoState createState() =>
      _BotaoIniciarExecucaoServicoState();
}

class _BotaoIniciarExecucaoServicoState
    extends State<BotaoIniciarExecucaoServico> {
  var json;
  var element;
  var osid;
  var token;
  var empresaid;

  getchecklist(empresaid, Json) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var osid;
    List os = json.decode(Json);
    print("ORDEM: $Json");
    os.forEach((element) async {
      osid = element['id'];
      print("OSID $osid");
      String check = await GetChecklistOS().obter(empresaid, osid);
      print("Check $check");
      opcs.setString("${osid}@checklist", check);
    });
  }

  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    empresaid = opcs.getInt('sessionid');
    element = jsonDecode(json);
    token = opcs.getString("${empresaid}@token")!;
    osid = element['id'];
    IniciaServico().iniciar(token, osid);
    getchecklist(empresaid, json);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        getdata();
        Navigator.push(
          context,
          // MaterialPageRoute(builder: (context) => CheckInTela()),
          MaterialPageRoute(builder: (context) => OsEmExecucao()),
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Color(0xFF00204E), // Cor do botão
        shadowColor: Colors.black.withOpacity(0.2), // Cor da sombra
        elevation: 4.0, // Elevação da sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Border radius do botão
        ),
      ),
      child: Center(
        child: Text(
          'Iniciar Execução de Serviço',
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}
