import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OsService {
  var empresaId;

  OsService({required this.empresaId});
  Future<List<dynamic>> filterCompleted(List<dynamic> ordens) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    List<String> ordensAFinalizar = opcs.getStringList("osIDaFinalizar") ?? List.empty();
    List<String> ordensAOcultar = opcs.getStringList("osAOcultar") ?? List.empty();

    return ordens.where((os) => !(ordensAFinalizar.contains(os['id'].toString()) || ordensAOcultar.contains(os['id'].toString()))).toList();
  }

  Future<List<dynamic>> getOsFuturas({showCompleted = false}) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final jsonfuturas = opcs.getString("${empresaId}@GetOSFuturas");

    List<dynamic> futuras = jsonDecode(jsonfuturas!);

    if (showCompleted) {
      return futuras;
    }

    return filterCompleted(futuras);
  }

  Future<List<dynamic>> getOsAmanha({showCompleted = false}) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final jsonamanha = opcs.getString("${empresaId}@GetOSAmanha");

    List<dynamic> amanha = jsonDecode(jsonamanha!);

    if (showCompleted) {
      return amanha;
    }

    return filterCompleted(amanha);
  }

  Future<List<dynamic>> getOsHoje({showCompleted = false}) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final jsonhoje = opcs.getString("${empresaId}@GetOSDia");

    List<dynamic> hoje = jsonDecode(jsonhoje!);

    if (showCompleted) {
      return hoje;
    }

    return filterCompleted(hoje);
  }

  Future<List<dynamic>> getOsAtrasadas({showCompleted = false}) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final jsonatrasadas = opcs.getString("${empresaId}@GetOSAtrasadas");

    List<dynamic> atrasadas = jsonDecode(jsonatrasadas!);

    if (showCompleted) {
      return atrasadas;
    }

    return filterCompleted(atrasadas);
  }



}
