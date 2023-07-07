import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class enviaconclusao{
  enviar()async{
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var  osid = element['id'];
    var itensconcjson = opcs.getString("conclusaoItens");
    var itenscon = jsonDecode(itensconcjson!);

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{"dataConclusaoOs": "${itenscon["dataConclusao"]}","observacaoOs": "${itenscon["observacoes"]}","hodometro": ${itenscon["hodometro"]},"etapa": "DESLOCAMENTO"\n}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/dadosos/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}