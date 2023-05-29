import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetOSAtrasadas{
  //obtem as os atrasadas
    obter() async {
      SharedPreferences opcs = await SharedPreferences.getInstance();
      var token = opcs.getString("token")!;
     var retorno;
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = '{\n  "value": {\n    "tipo": 2\n  },\n  "first": 0,\n  "rows": 100,\n  "sorts": [\n    {\n      "campo": "id",\n      "asc": true\n    }\n  ]\n}';

    var url = Uri.parse('${Urlconst().url}ordem_servico/tecnico');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    retorno = jsonDecode(res.body);
    print("atrasadas \n ${retorno}");
    return res.body;
  }
}
