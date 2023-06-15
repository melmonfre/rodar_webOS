import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class GetMotivosOS{
  obter(empresaid, OSID) async {

    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}ordem_servico/motivos/$OSID');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    else{
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }
}
