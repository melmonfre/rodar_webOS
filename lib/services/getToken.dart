import 'dart:convert';

import 'package:flutter/material.dart';
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
  Future<String> obter(var token) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var idvelho = opcs.getInt("sessionid");
    zerarcache(idvelho);
    var retorno;
    var bearer;

    var url = Uri.parse('${Urlconst().url}token/codigo/${token}');
    var res = await http.get(url);
    if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    retorno = jsonDecode(res.body);
    bearer = retorno['token'];
    var dados = await GetDadoslogin().fazlogin(bearer);
    var data = jsonDecode(dados);
    var emp = data['empresa'];
    var empresa = jsonEncode(emp);
    setempresas(empresa);
    var empresaid = emp['id'];
    opcs.setInt("sessionid", empresaid);

    opcs.setString("${empresaid}@token", bearer);
    sincronizar(empresaid);
    opcs.setString("${empresaid}@login", dados);

    return ("Sucesso");
  }

  sincronizar(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    debugPrint("sincronizando...");

    // await opcs.setBool("carregando", true);

    try {
      String amanha = await GetOSAmanha().obter(empresaid);

      await opcs.setBool("carregando", true);

      String atrasadas = await GetOSAtrasadas().obter(empresaid);
      String dodia = await GetOSDia().obter(empresaid);
      String futuras = await GetOSFuturas().obter(empresaid);
      String equiptecnico = await getequiptec().obter(empresaid);

      await opcs.setString("${empresaid}@GetOSAmanha", amanha);
      await opcs.setString("${empresaid}@GetOSAtrasadas", atrasadas);
      await opcs.setString("${empresaid}@GetOSDia", dodia);
      await opcs.setString("${empresaid}@GetOSFuturas", futuras);
      await opcs.setString("${empresaid}@getequiptec", equiptecnico);

      await getequiptec().obterClienteIter(empresaid);

      await checklist(empresaid, dodia);
      await checklist(empresaid, amanha);
      await checklist(empresaid, atrasadas);
      await checklist(empresaid, futuras);
    } catch (e) {
      debugPrint(e.toString());
    }

    await opcs.setBool("carregando", false);
  }

  zerarcache(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("${empresaid}@GetOSAmanha", "");
    opcs.setString("${empresaid}@GetOSAtrasadas", "");
    opcs.setString("${empresaid}@GetOSDia", "");
    opcs.setString("${empresaid}@GetOSFuturas", "");
    opcs.setString("${empresaid}@getequiptec", "");
  }

  checklist(empresaid, nf) async {
    var osid;
    var check;
    var motivos;
    var nota = jsonDecode(nf);
    var notinha;
    try {
      notinha = nota[0];
      osid = notinha['id'];
      SharedPreferences opcs = await SharedPreferences.getInstance();
      try {
        check = await GetChecklistOS().obter(empresaid, osid);
        if (check != null) {
          opcs.setString("${osid}@checklist", check);
        }
      } catch (e) {
        check = await GetChecklistOS().obter(empresaid, osid);
        opcs.setString("${osid}@checklist", check);
      }
      try {
        motivos = await GetMotivosOS().obter(empresaid, osid);
        if (motivos != null) {
          opcs.setString("${osid}@motivos", motivos);
        }
      } catch (e) {
        motivos = await GetMotivosOS().obter(empresaid, osid);
        opcs.setString("${osid}@motivos", motivos);
      }
    } catch (e) {
      // rethrow;
    }
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
