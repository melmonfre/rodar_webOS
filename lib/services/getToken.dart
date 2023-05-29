import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getToken{
 void obter(var token) async {
  var retorno;
  var bearer;
  var url = Uri.parse('${Urlconst().url}token/codigo/${token}');
  var res = await http.get(url);
  if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
  retorno = jsonDecode(res.body);
  print(retorno['token']);
  bearer = retorno['token'];
  SharedPreferences opcs = await SharedPreferences.getInstance();
  opcs.setString("token",bearer);
}
}