import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/pages/check_in/tela_check_in.dart';
import 'package:rodarwebos/pages/check_out/tela_check_out.dart';
import 'package:rodarwebos/pages/conclusao/tela_conclusao.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:rodarwebos/pages/fotos/telas_fotos/foto_hodometro.dart';
import 'package:rodarwebos/pages/motivos/tela_relate_motivos.dart';
import 'package:rodarwebos/pages/responsavel/tela_responsavel.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Etapa {
  CHECKIN,
  EQUIPAMENTOS,
  ACESSORIOS,
  FOTOS,
  DESLOCAMENTO,
  CHECKOUT,
  CONCLUSAO,
  RESPONSAVEL,
  MOTIVOS,
}

extension EtapaExtension on Etapa {
  String get key {
    switch (this) {
      case Etapa.CHECKIN:
        return "checkin-etapa";
      case Etapa.EQUIPAMENTOS:
        return "equipamentos-etapa";
      case Etapa.ACESSORIOS:
        return "acessorios-etapa";
      case Etapa.FOTOS:
        return "fotos-etapa";
      case Etapa.DESLOCAMENTO:
        return "deslocamento-etapa";
      case Etapa.CHECKOUT:
        return "checkout-etapa";
      case Etapa.CONCLUSAO:
        return "conclusao-etapa";
      case Etapa.RESPONSAVEL:
        return "responsavel-etapa";
      case Etapa.MOTIVOS:
        return "motivos-etapa";
      default:
        return "";
    }
  }
}

class EtapaItem {
  String name;
  Widget Function() etapaWidget;
  bool isDone;
  Etapa enumValue;
  bool enabled;

  EtapaItem(
      {required this.name,
      required this.etapaWidget,
      required this.isDone,
      required this.enumValue,
      required this.enabled});
}

class SelectedOsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  Map<String, dynamic>? _selectedOs;
  // ignore: prefer_final_fields
  List<EtapaItem> _etapas = [
    EtapaItem(
        enumValue: Etapa.CHECKIN,
        name: "Check-in",
        etapaWidget: CheckInTela.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.EQUIPAMENTOS,
        name: "Equipamentos",
        etapaWidget: Equipamentos.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.ACESSORIOS,
        name: "Acessórios",
        etapaWidget: Acessorios.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.FOTOS,
        name: "Fotos",
        etapaWidget: FotoHodometro.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.DESLOCAMENTO,
        name: "Deslocamento",
        etapaWidget: TelaDeslocamento.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.CHECKOUT,
        name: "Check-out",
        etapaWidget: CheckOutTela.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.MOTIVOS,
        name: "Motivos",
        etapaWidget: RelateMotivo.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.CONCLUSAO,
        name: "Conclusão",
        etapaWidget: TelaConclusao.new,
        isDone: false,
        enabled: true),
    EtapaItem(
        enumValue: Etapa.RESPONSAVEL,
        name: "Responsável",
        etapaWidget: TelaResponsavel.new,
        isDone: false,
        enabled: true),
  ];

  bool get hasSelectedOs => _selectedOs != null;
  int get osId => _selectedOs!['id'];
  EtapaItem? getEtapa(Etapa etapa) => _etapas.firstWhere((element) => element.enumValue == etapa);

  void setSelectedOs(Map<String, dynamic>? selectedOs) {
    _selectedOs = selectedOs;
    _loadEtapas();
  }

  void _loadEtapas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final json = opcs.getString("SelectedOS");
    final os = jsonDecode(json!);

    final osId = os['id'];

    bool hasAcessorios = false;
    try {
      List<dynamic> acessorios = os["acessorios"];
      hasAcessorios = acessorios.isNotEmpty;
    } catch (e) {
      hasAcessorios = false;
    }

    for (var e in _etapas) {
      dynamic hasValue = opcs.get(buildStorageKeyString(osId, e.enumValue.key));

      debugPrint(
          'etapa: ' + e.enumValue.name.toString() + ' - is done: ' + (hasValue != null).toString());

      bool enabled = e.enabled;

      switch (e.enumValue) {
        case Etapa.ACESSORIOS:
          enabled = hasAcessorios;
          break;
        case Etapa.MOTIVOS:
          enabled = false;

          try {
            List<dynamic> equipamentos = _selectedOs!["equipamentos"];

            equipamentos?.forEach((equipamento) {
              final tipo = equipamento["tipo"];

              if (tipo == "MANUTENCAO") {
                enabled = true;
              }
            });
          } catch (e) {
            debugPrint('erro load etapas - is manutencao: ' + e.toString());
          }
          break;
        default:
          // do nothing
      }
      if (e.enumValue == Etapa.ACESSORIOS) {}

      if (e.enumValue == Etapa.MOTIVOS) {}

      e.isDone = hasValue != null;
      e.enabled = enabled;
    }

    notifyListeners();
  }

  List<EtapaItem> getEtapas() {
    return _etapas;
  }

  void updateEtapasState() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    for (EtapaItem etapa in _etapas) {
      Object? etapaObj = opcs.get(buildStorageKeyString(osId, etapa.enumValue.key));
      etapa.isDone = etapaObj != null;
    }

    bool isAllDone = true;

    notifyListeners();
  }

  Map<String, dynamic> getOs() {
    return _selectedOs!;
  }
}

final selectedOsProvider = ChangeNotifierProvider<SelectedOsModel>((ref) {
  return SelectedOsModel();
});
