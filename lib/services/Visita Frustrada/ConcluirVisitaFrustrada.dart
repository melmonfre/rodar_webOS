import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class concluivf{
  concluir() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var dadosdeslocamento = opcs.getString("dadosdeslocamento");
    var deslocamento = jsonDecode(dadosdeslocamento!);
    var os = opcs.getString("SelectedOS");
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var motivo = opcs.getString("motivovf");
    var element = jsonDecode(os!);
    var osid = element['id'];
    var DistanciaTec = deslocamento['distanciaPercorrida'];
    var distanciacalc = deslocamento['distanciaCalculada'];
    var valorDeslocamentoTec = deslocamento['valor'];
    var pedagioTec = deslocamento['pedagio'];
    var motivoDiv = element['motivoDiv'];
    List<String>? base64images = opcs.getStringList("base64vf");
    var localGps = "${opcs.getStringList("latitude")},${opcs.getStringList("longitude")}";

    enviamotivosvf(osid, token, DistanciaTec, valorDeslocamentoTec, pedagioTec, motivoDiv, motivo, localGps);
    enviardiversasfotosvf(osid, token, base64images);
    enviardeslocamentovf(osid, token, distanciacalc, DistanciaTec, pedagioTec);

  }

  enviamotivosvf(osid, token,  DistanciaTec,valorDeslocamentoTec, pedagioTec, motivoDiv, motivo, localGps) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = '{\n    "base64":[\n        ""\n    ],\n    "DistanciaTec":$DistanciaTec,\n    "valorDeslocamentoTec":$valorDeslocamentoTec,\n    "pedagioTec":$pedagioTec,\n    "motivoDiv":$motivoDiv,\n    "motivo":$motivo,\n    "localGps":$localGps,\n    "etapa": "SERVICO_INICIADO"\n  }';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarmotivovf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      List<String>? ids = opcs.getStringList("osIDaFinalizarvf");
      if(ids == null){
        ids = [];
        ids.add("$osid");
      }
      opcs.setStringList("osIDaFinalizarvf", ids);
      opcs.setString("${osid}@OSaFinalizarvf", data);

      throw Exception('enviamotivosvf http.post error: statusCode= $status');
    }
    print("VISITA FRUSTRADA");
    print(res.body);
  }


  enviardiversasfotosvf(osid, token, image) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{\n    "base64":        "$image"\n , "idsRemove":[], \n  "etapa": "SERVICO_INICIADO"\n  }';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardiversasfotosvf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      opcs.setString("${osid}@OSaFinalizarvfoto", data);
      throw Exception('enviardiversasfotosvf http.post error: statusCode= $status');
    }
    print(res.body);
  }

  enviardeslocamentovf(osid, token, distanciaTec, distanciacalc, pedagioTec) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{"distanciaTec":$distanciacalc,"distanciaTec":$distanciaTec,"pedagioTec":$pedagioTec}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardeslocamento/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      opcs.setString("${osid}@OSaFinalizarvfdeslocamento", data);
      throw Exception('enviardeslocamentovf http.post error: statusCode= $status');
    }
    print(res.body);
  }
}