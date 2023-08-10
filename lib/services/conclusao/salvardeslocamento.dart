import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class salvardeslocamento{
  enviar() async {
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
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };


      final data = '{"distanciaTec":$distanciacalc,"distanciaTec":$DistanciaTec,"pedagioTec":$pedagioTec}';
      final url = Uri.parse('${Urlconst().url}ordem_servico/deslocamento/108527');

      final res = await http.post(url, headers: headers, body: data);
      final status = res.statusCode;
      if (status != 200) throw Exception('http.post error: statusCode= $status');

      print(res.body);
  }
}