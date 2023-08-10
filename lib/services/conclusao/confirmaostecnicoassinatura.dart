import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class confirmassinatura{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var base64 = opcs.getString("assinaturaconfirmacao");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var  osid = element['id'];
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data = '{\n    "base64": "$base64",\n    "referencia": "Assinatura Tecnico",\n    "etapa": "CONCLUSAO"\n}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/confirmaostecnico/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}