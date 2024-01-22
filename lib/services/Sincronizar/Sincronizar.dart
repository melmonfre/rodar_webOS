import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/services/Sincronizar/sincronizarOffline.dart';
import 'package:rodarwebos/services/debug_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../Constantes/Urlconst.dart';

class SincronizarOS {
  sincronize() async {
    await sincronizarFinalizadas();
    await sincronizarFrustradas();
  }

  sincronizarFrustradas() async {
    await DebugService.removeDuplicatesIdsAFinalizar();
    SharedPreferences opcs = await SharedPreferences.getInstance();

    List<String>? idsVF = opcs.getStringList("osIDaFinalizarvf");
    idsVF?.forEach((osid) {
      var body;
      body = opcs.getString("${osid}@OSaFinalizarvfoto");
      enviardiversasfotosvf(body, osid);
      body = opcs.getString("${osid}@OSaFinalizarvfdeslocamento");
      enviardeslocamento(osid, body);
      body = opcs.getString("${osid}@OSaFinalizarvf");
      enviamotivosvf(body, osid);
    });
    final idsQueFalharam = [];

    if (idsVF != null) {
      final futures = await Future.wait(idsVF.map((osid) {
        return Future(() async {
          try {
            var body;

            List<Future<dynamic>> futuresToWait = [];

            body = opcs.getString("${osid}@OSaFinalizarvfoto");
            futuresToWait.add(enviardiversasfotosvf(body, osid));
            body = opcs.getString("${osid}@OSaFinalizarvfdeslocamento");
            futuresToWait.add(enviardeslocamento(osid, body));
            body = opcs.getString("${osid}@OSaFinalizarvf");
            futuresToWait.add(enviamotivosvf(body, osid));

            await Future.wait(futuresToWait);

            return true;
          } catch (e) {
            idsQueFalharam.add(osid);
            return false;
          }
        });
      }));
    }
  }

  sincronizarFinalizadas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String>? ids = opcs.getStringList('osIDaFinalizar');
    List<String> idsQueFalharam = [];

    if (ids != null) {
      final futures = await Future.wait(ids.map((osid) {
        return Future(() async {
          try {
            await syncoff().enviar(osid);
            return true;
          } catch (e) {
            idsQueFalharam.add(osid);
            return false;
          }
        });
      }));

      if (idsQueFalharam.isNotEmpty) {
        debugPrint('algumas os falharam');
      }
    }
  }

  enviardeslocamento(osid, body) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body;

    final url =
        Uri.parse('${Urlconst().url}ordem_servico/enviardeslocamento/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception(
          'enviardeslocamento http.post error: statusCode= $status');
    } else {
      List<String>? ids = opcs.getStringList("osIDaFinalizarvf");
      ids?.remove(osid.toString());
      opcs.setStringList("osIDaFinalizarvf", ids!);
      print(res.body);
    }
    print(res.body);
  }

  enviardiversasfotosvf(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body;

    final url =
        Uri.parse('${Urlconst().url}ordem_servico/enviardiversasfotos/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    }
    opcs.remove("${osid}@OSaFinalizarvfoto");
    List<String>? ids = opcs.getStringList("osIDaFinalizarvf");
    ids?.remove(osid.toString());
    opcs.setStringList("osIDaFinalizarvf", ids!);
    print(res.body);
  }

  enviamotivosvf(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body;
    final url =
        Uri.parse('${Urlconst().url}ordem_servico/enviarmotivovf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    } else {
      opcs.remove("${osid}@OSaFinalizarvf");
      List<String>? ids = opcs.getStringList("osIDaFinalizarvf");
      ids?.remove(osid.toString());
      opcs.setStringList("osIDaFinalizarvf", ids!);
      print(res.body);
    }
  }
}
