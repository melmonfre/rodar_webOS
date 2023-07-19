import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class salvareqtec{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var json = await opcs.getString("SelectedOS");
    var dados = jsonDecode(json!);
    var  osid = dados['id'];
    var equipamentos = jsonEncode(dados['equipamentos']);



    /*"EquipamentoInstaladoID": eqnovosid,
    "EquipamentoInstaladoCodigo": selecionadonovo,
    "EquipamentosRemovidoID": "",
    "EquipamentoRemovidoCodigo": "",
    "localInstalacao": localInstalacao,*/

    var jsoneqs = opcs.getString("EQProcess");
    var eqs = jsonDecode(jsoneqs!);
    if(eqs["control"] == "RETIRADA"){

    Map<String,dynamic>  eqretiradoTec ={
    "id"	:	eqs['EquipamentosRemovidoID'],
    "codigo"	: "${eqs['EquipamentoRemovidoCodigo']}",
    "documento"	:	"${eqs['EquipamentoRemovidoDocumento']}",
    "status"	:	"INSTALADO",
    "cancelado"	:	false
    };
    Map<String, dynamic> equipaments = {
    "id": eqs["EquipamentosRemovidoID"],
    "tipo": "RETIRADA",
    "stringEquipamento":"Retirada",
    "equipamentoRetiradoTec": eqretiradoTec,
    "tipoTec" : "RETIRADA",
    "situacao" : true,
    };
    dados["equipamentos"] = equipaments;
    json = jsonEncode(dados);
    } else if(eqs["control"] == "INSTALACAO"){

      Map<String,dynamic>  eqretiradoTec ={
        "id"	:	eqs['EquipamentoInstaladoID'],
        "codigo"	:	eqs['EquipamentoInstaladoCodigo'],
        "documento"	:	eqs['EquipamentoInstaladoDocumento'],
        "status"	:	"DISPONIVEL",
        "cancelado"	:	false

      };


      Map<String, dynamic> equipaments = {
        "id": eqs["EquipamentosRemovidoID"],
        "tipo": "INSTALACAO",
        "stringEquipamento":"Instalacao",
        "equipamentoTec": eqretiradoTec,
        "tipoTec" : "INSTALACAO",
        "situacao" : true,
      };
      dados["equipamentos"] = equipaments;
      json = jsonEncode(dados);
    } else if(eqs["control"] == "INSTALAÇÃO"){

  Map<String,dynamic>  eqretiradoTec ={
  "id"	:	eqs['EquipamentoInstaladoID'],
  "codigo"	:	eqs['EquipamentoInstaladoCodigo'],
  "documento"	:	eqs['EquipamentoInstaladoDocumento'],
  "status"	:	"DISPONIVEL",
  "cancelado"	:	false

  };
  Map<String, dynamic> equipaments = {
  "id": eqs["EquipamentosRemovidoID"],
  "tipo": "INSTALAÇÃO",
  "stringEquipamento":"Instalação",
  "equipamentoTec": eqretiradoTec,
  "tipoTec" : "INSTALAÇÃO",
  "situacao" : true,
  };
  dados["equipamentos"] = equipaments;
  json = jsonEncode(dados);
  }
    var body ='$json';
    final data =  body;

    final url = Uri.parse('${Urlconst().url}ordem_servico/salvar_equipamentos_tecnico');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}
