import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetOSAmanha{
  //obtem as os de amanhã
    obter(empresaid) async {
      SharedPreferences opcs = await SharedPreferences.getInstance();
      var token = opcs.getString("${empresaid}@token")!;
     var retorno;
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = ' {\n    "tipo": 1\n  }';
    var url = Uri.parse('${Urlconst().url}ordem_servico/tecnico');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    else{
      print(res.body);
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }
}
