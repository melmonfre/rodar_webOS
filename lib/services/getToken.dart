import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';
import 'package:rodarwebos/services/OS/GetMotivosOS.dart';
import 'package:rodarwebos/services/OS/GetOSAmanha.dart';
import 'package:rodarwebos/services/OS/GetOSAtrasadas.dart';
import 'package:rodarwebos/services/OS/GetOSDoDia.dart';
import 'package:rodarwebos/services/OS/GetOSFuturas.dart';
import 'package:rodarwebos/services/OS/GetEquipamentosTecnico.dart';
import 'package:rodarwebos/services/OS/GetDadoslogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OS/GetChecklistOS.dart';

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
    var emp =data['empresa'];
    var empresa = jsonEncode(emp);
    setempresas(empresa);
    var empresaid = emp['id'];
    print(empresaid);
    opcs.setString("${empresaid}@token", bearer);
   sincronizar(empresaid);
    opcs.setString("${empresaid}@login", dados);
  }

  sincronizar(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

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

    checklist(empresaid ,dodia);
    checklist(empresaid, amanha);
    checklist(empresaid, atrasadas);
    checklist(empresaid, futuras);
  }
  
  zerarcache(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("${empresaid}@GetOSAmanha", "");
    opcs.setString("${empresaid}@GetOSAtrasadas", "");
    opcs.setString("${empresaid}@GetOSDia", "");
    opcs.setString("${empresaid}@GetOSFuturas", "");
    opcs.setString("${empresaid}@getequiptec", "");
  }
  checklist( empresaid, nf) async {
    var osid;
    var check;
    var motivos;
    var nota = jsonDecode(nf);
    var notinha;
    try {
      notinha = nota [0];
      osid = notinha ['id'];
      SharedPreferences opcs = await SharedPreferences.getInstance();
      try{
        check = await GetChecklistOS().obter(empresaid, osid);
        if(check != null){
          opcs.setString("${osid}@checklist", check);
        }
      } catch(e) {
        opcs.remove("${osid}@checklist");
      }
      try{
        motivos = await GetMotivosOS().obter(empresaid, osid);
        if(motivos != null){
          print("OS $osid");
          print("Motivos: ${motivos}");
          opcs.setString("${osid}@motivos", motivos);
        }
      } catch(e) {
        opcs.remove("${osid}@motivos");
      }
    } catch(e){
      print("isso não é um erro");
    }
  }
  getempresas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String>? listaempresas = opcs.getStringList("empresas");
    print(listaempresas);
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
    print("EMPRESA $empresa");
    if (opcs.getStringList("empresas") == null) {
      empresas.add(empresa);
      opcs.setStringList("empresas", empresas);
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
