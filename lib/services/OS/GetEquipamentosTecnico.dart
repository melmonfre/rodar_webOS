//exibe uma lista de equipamentos disponiveis vinculados ao tecnico
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

// TODO: testar obterVeiculo e obterCliente

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

  bool _isOld(String? addedOn) {
    // verificar se a ultima atualizacao dos equipamentos é antiga
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

    return isOld;
  }

  _obterClienteIter(
      {required SharedPreferences opcs,
      required dynamic clienteId,
      required dynamic empresaId}) async {
    try {
      bool exists = opcs.getString("${clienteId}@EquipamentosCliente") != null;
      String? addedOn = opcs.getString("${clienteId}@EquipamentosClienteAddedOn");

      bool isOld = _isOld(addedOn);

      if (!exists || isOld) {
        final data = await _obterCliente(empresaId, clienteId);
        await opcs.setString("${clienteId}@EquipamentosCliente", data);

        String timestamp = DateTime.timestamp().toString();
        await opcs.setString("${clienteId}@EquipamentosClienteAddedOn", timestamp);
      }
    } catch (e) {
      debugPrint("erro equipamento cliente (${clienteId}): ${e.toString()}");
      debugPrintStack();
    }
  }

  _obterVeiculoIter(
      {required SharedPreferences opcs,
      required dynamic veiculoId,
      required dynamic empresaId}) async {
    try {
      bool exists = opcs.getString("${veiculoId}@EquipamentosVeiculo") != null;
      String? addedOn = opcs.getString("${veiculoId}@EquipamentosVeiculoAddedOn");

      bool isOld = _isOld(addedOn);

      if (!exists || isOld) {
        final data = await _obterVeiculo(empresaId, veiculoId);
        await opcs.setString("${veiculoId}@EquipamentosVeiculo", data);

        String timestamp = DateTime.timestamp().toString();
        await opcs.setString("${veiculoId}@EquipamentosVeiculoAddedOn", timestamp);
      }
    } catch (e) {
      debugPrint("erro equipamento veiculo (${veiculoId}): ${e.toString()}");
      debugPrintStack();
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
      final clienteId = os["veiculo"]["cliente"]["id"];
      final veiculoId = os["veiculo"]["id"];

      await _obterClienteIter(
        clienteId: clienteId,
        empresaId: empresaid,
        opcs: opcs,
      );

      await Future.delayed(const Duration(seconds: 1));

      await _obterVeiculoIter(
        veiculoId: veiculoId,
        empresaId: empresaid,
        opcs: opcs,
      );

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  _obterVeiculo(empresaid, veiculoId) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}equipamento/list_equipamentos_veiculo/${veiculoId}');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200)
      throw Exception('http.get error: statusCode= ${res.statusCode}');
    else {
      String source = Utf8Decoder().convert(res.bodyBytes);
      return source;
    }
  }

  _obterCliente(empresaid, clienteId) async {
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
