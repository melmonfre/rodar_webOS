
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:rodarwebos/services/OS/GetOSAmanha.dart';
import 'package:rodarwebos/services/OS/GetOSAtrasadas.dart';
import 'package:rodarwebos/services/OS/GetOSDoDia.dart';
import 'package:rodarwebos/services/OS/GetOSFuturas.dart';
import 'package:rodarwebos/services/OS/GetEquipamentosTecnico.dart';
import 'package:rodarwebos/services/OS/GetDadoslogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class getToken {
  void obter(var token) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var retorno;
    var bearer;

    var url = Uri.parse('${Urlconst().url}token/codigo/${token}');
    var res = await http.get(url);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    retorno = jsonDecode(res.body);
    print(retorno['token']);
    bearer = retorno['token'];
    var dados = await GetDadoslogin().fazlogin(bearer);
    var data = jsonDecode(dados);
    var empresa = data['empresa'];
    setempresas(empresa);
    var empresaid = empresa['id'];
    opcs.setString("${empresaid}@token", bearer);
    String amanha = await GetOSAmanha().obter(empresaid);
    String atrasadas = await GetOSAtrasadas().obter(empresaid);
    String dodia = await GetOSDia().obter(empresaid);
    String futuras = await GetOSFuturas().obter(empresaid);
    String equiptecnico = await getequiptec().obter(empresaid);
    opcs.setString("${empresaid}@GetOSAmanha", amanha);
    opcs.setString("${empresaid}@GetOSAtrasadas", atrasadas);
    opcs.setString("${empresaid}@GetOSDia", dodia);
    opcs.setString("${empresaid}@GetOSFuturas", futuras);
    opcs.setString("${empresaid}@getequiptec", equiptecnico);
    opcs.setString("${empresaid}@login", dados);
  }

  getempresas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String>? listaempresas = opcs.getStringList("empresas");
    return listaempresas;
  }

  getlogin(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var login = opcs.getString("${empresaid}@login");
    return login;
  }

  Future<void> setempresas(empresa) async {
    List<String> empresas = [];
    SharedPreferences opcs = await SharedPreferences.getInstance();
    if (opcs.getStringList("empresas") == null) {
      empresas.add(empresa);
    } else {
      List<String>? listaempresas = opcs.getStringList("empresas");
      if (listaempresas!.contains(empresa)) {
      } else {
        listaempresas.add(empresa);
        opcs.setStringList("empresas", listaempresas);
      }
    }
  }
}
