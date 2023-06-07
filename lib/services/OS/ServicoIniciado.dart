import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Constantes/Urlconst.dart';
class IniciaServico{
  iniciar(token, osid) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}ordem_servico/servicoiniciado/${osid}');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) throw Exception(
        'http.get error: statusCode= ${res.statusCode}');
    else{
      print(res.body);
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }

  }
}