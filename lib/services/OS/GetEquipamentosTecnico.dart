//exibe uma lista de equipamentos disponiveis vinculados ao tecnico
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';
class getequiptec{
  obter(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}equipamento/list_equipamentos_tecnico');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    else{
      print(res.body);
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }
}
