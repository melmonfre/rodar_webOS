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
    var valorDeslocamentoTec = deslocamento['valor'];
    var pedagioTec = deslocamento['pedagio'];
    var motivoDiv = element['motivoDiv'];
    List<String>? base64images = opcs.getStringList("base64vf");
    var localGps = opcs.getStringList("local"); //TODO: implementar local gps
    if(base64images!.isNotEmpty){
      if(base64images.length > 1){
        //TODO: fazer metodo enviar varias imagens
      }
      enviamotivosvf(osid, token, base64images[0], DistanciaTec, valorDeslocamentoTec, pedagioTec, motivoDiv, motivo, localGps);
    }


  }

  enviamotivosvf(osid, token, image,  DistanciaTec,valorDeslocamentoTec, pedagioTec, motivoDiv, motivo, localGps) async {
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{\n    "base64":[\n        "$image"\n    ],\n    "DistanciaTec":$DistanciaTec,\n    "valorDeslocamentoTec":$valorDeslocamentoTec,\n    "pedagioTec":$pedagioTec,\n    "motivoDiv":$motivoDiv,\n    "motivo":$motivo,\n    "localGps":$localGps,\n    "etapa": "SERVICO_INICIADO"\n  }';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarmotivovf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }

}