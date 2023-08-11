import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class enviaconclusao {
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var osid = element['id'];
    var itensconcjson = opcs.getString("conclusaoItens");
    var itenscon = jsonDecode(itensconcjson!);

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var conclusao =
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(itenscon["dataConclusao"]);
    final data =
        '{"dataConclusaoOs": "${DateFormat('yyyy-MM-ddTHH:mm:ss.SSS-03:00').format(conclusao)}","observacaoOs": "${itenscon["observacoes"]}","hodometro": ${itenscon["hodometro"]},"etapa": "DESLOCAMENTO"\n}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/dadosos/$osid');
    print(data);
    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    final body = res.body;
    if (status != 200)
      throw Exception('http.post error: statusCode= $status body= $body');

    print(res.reasonPhrase);
    print(res.request);
    print(res.headers);
    print(res.body);
  }
}
