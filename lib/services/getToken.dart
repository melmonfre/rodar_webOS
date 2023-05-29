import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:rodarwebos/services/GetOSAmanha.dart';
import 'package:rodarwebos/services/GetOSAtrasadas.dart';
import 'package:rodarwebos/services/GetOSDoDia.dart';
import 'package:rodarwebos/services/GetOSFuturas.dart';
import 'package:rodarwebos/services/GetEquipamentosTecnico.dart';
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
  String amanha = await GetOSAmanha().obter();
  String atrasadas = await GetOSAtrasadas().obter();
  String dodia =  await GetOSDia().obter();
  String futuras = await GetOSFuturas().obter();
  String equiptecnico = await getequiptec().obter();
  opcs.setString("token",bearer);
  opcs.setString("GetOSAmanha",amanha);
  opcs.setString("GetOSAtrasadas",atrasadas);
  opcs.setString("GetOSDia",dodia);
  opcs.setString("GetOSFuturas",futuras);
  opcs.setString("getequiptec",equiptecnico);
}
}