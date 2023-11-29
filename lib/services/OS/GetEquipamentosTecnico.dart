//exibe uma lista de equipamentos disponiveis vinculados ao tecnico
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class getequiptec {
  obter(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}equipamento/list_equipamentos_tecnico');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    else {
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }

  obterClienteIter(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final osAmanha = jsonDecode(opcs.getString("${empresaid}@GetOSAmanha")!);
    final osAtrasadas = jsonDecode(opcs.getString("${empresaid}@GetOSAtrasadas")!);
    final osDia = jsonDecode(opcs.getString("${empresaid}@GetOSDia")!);
    final osFuturas = jsonDecode(opcs.getString("${empresaid}@GetOSFuturas")!);

    List<dynamic> todas = [];

    for (final element in [osAmanha, osAtrasadas, osDia, osFuturas]) {
      todas.addAll(element);
    }

    for (final os in todas) {
      dynamic clienteId;
      try {
        clienteId = os["veiculo"]["cliente"]["id"];

        bool exists = opcs.getString("${clienteId}@EquipamentosCliente") != null;
        String? addedOn = opcs.getString("${clienteId}@EquipamentosClienteAddedOn");

        // verificar se a ultima atualizacao dos equipamentos do cliente é antiga
        bool isOld = false;
        int isOldAfterThisMuch = 15000;
        
        if (addedOn != null) {
          try {
            var difference = DateTime.now().difference(DateTime.parse(addedOn));
            isOld = difference.inMilliseconds > isOldAfterThisMuch;
          } catch (e) {
            isOld = true;
            debugPrint(e.toString());
            debugPrintStack();
          }
        }

        if (exists || isOld) {
          final data = await obterCliente(empresaid, clienteId);
          await opcs.setString("${clienteId}@EquipamentosCliente", data);

          String timestamp = DateTime.timestamp().toString();
          await opcs.setString("${clienteId}@EquipamentosClienteAddedOn", timestamp);
        }
      } catch (e) {
        debugPrint("error equipamento cliente (${clienteId}): ${e.toString()}");
        debugPrintStack();
      }
    }
  }

  obterCliente(empresaid, clienteId) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url =
        Uri.parse('${Urlconst().url}equipamento/list_equipamentos_tecnico_cliente/${clienteId}');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    else {
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }
}
