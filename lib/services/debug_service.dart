import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rodarwebos/services/Sincronizar/sincronizarOffline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugService {
  static void _saveFileToDownloads(String name, String content) async {
    Directory generalDownloadsDir = Directory('/storage/emulated/0/Download');

    File file = File(generalDownloadsDir.path + "/" + name);

    file.writeAsStringSync(content);
  }

  static void saveOrdensASincronizarToDownloads(BuildContext context) async {
    await removeDuplicatesIdsAFinalizar();

    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String>? ids = opcs.getStringList('osIDaFinalizar');

    List<dynamic> aFinalizarList = [];

    ids?.forEach((osid) {
      final dataStr = opcs.getString("${osid}@OSaFinalizardata");
      try {
        aFinalizarList.add(jsonDecode(dataStr!));
      } catch (e) {
        aFinalizarList.add(dataStr ?? osid.toString());
      }
    });

    List<dynamic> visitaFrustradaList = [];

    List<String>? idsVF = opcs.getStringList("osIDaFinalizarvf");

    idsVF?.forEach((osid) {
      final bodyFoto = opcs.getString("${osid}@OSaFinalizarvfoto");
      final bodyDeslocamento =
          opcs.getString("${osid}@OSaFinalizarvfdeslocamento");
      final bodyMotivo = opcs.getString("${osid}@OSaFinalizarvf");

      Map<String, dynamic> osBody = {
        'id': osid.toString(),
        'foto': bodyFoto ?? "",
        'deslocamento': bodyDeslocamento ?? "",
        'motivo': bodyMotivo ?? "",
      };

      try {
        osBody['foto'] = jsonDecode(bodyFoto!);
      } catch (e) {}

      try {
        osBody['deslocamento'] = jsonDecode(bodyDeslocamento!);
      } catch (e) {}
      try {
        osBody['motivo'] = jsonDecode(bodyMotivo!);
      } catch (e) {}

      visitaFrustradaList.add(osBody);
    });

    Map<String, dynamic> data = {
      'ordensAFinalizar': aFinalizarList,
      'visitaFrustrada': visitaFrustradaList,
    };

    DateTime now = DateTime.now();

    final datePortionOfFile = DateFormat('yyyy-MM-dd kk-mm-ss-SSS').format(now);

    final filename = 'ordens-a-sincronizar-${datePortionOfFile}.rekta';

    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }

    try {
      _saveFileToDownloads(filename, jsonEncode(data));
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Arquivo salvo na pasta Download.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content:
                Text('Algo deu errado ao salvar o arquivo. (${e.toString()})'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  static _saveFileToDownloadsUpdated(String filename, String content) async {
    await FileSaver.instance.saveFile(
        name: filename,
        bytes: Uint8List.fromList(content.codeUnits),
        mimeType: MimeType.text);
  }

  static removeDuplicatesIdsAFinalizar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    List<String>? ids = opcs.getStringList('osIDaFinalizar');
    if (ids != null) {
      ids = ids.toSet().toList();
      await opcs.setStringList("osIDaFinalizar", ids);
    }

    List<String>? idsVF = opcs.getStringList("osIDaFinalizarvf");
    if (idsVF != null) {
      idsVF = idsVF.toSet().toList();
      await opcs.setStringList("osIDaFinalizarvf", idsVF);
    }

    debugPrint('removidos: ids a finalizar duplicados.');
  }

  static limparListaDeOrdensOcultas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    await opcs.setStringList("osAOcultar", []);
  }
}
