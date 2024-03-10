import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/pages/check_in/tela_check_in.dart';
import 'package:rodarwebos/pages/check_out/tela_check_out.dart';
import 'package:rodarwebos/pages/conclusao/tela_conclusao.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
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

  EtapaItem(
      {required this.name,
      required this.etapaWidget,
      required this.isDone,
      required this.enumValue});
}

class SelectedOsModel extends ChangeNotifier {
  /// Internal, private state of the cart.
  Map<String, dynamic>? _selectedOs;
  // ignore: prefer_final_fields
  List<EtapaItem> _etapas = [
    EtapaItem(
        enumValue: Etapa.CHECKIN, name: "Check-in", etapaWidget: CheckInTela.new, isDone: false),
    EtapaItem(
        enumValue: Etapa.EQUIPAMENTOS,
        name: "Equipamentos",
        etapaWidget: Equipamentos.new,
        isDone: false),
    EtapaItem(
        enumValue: Etapa.ACESSORIOS,
        name: "Acessórios",
        etapaWidget: Acessorios.new,
        isDone: false),
    EtapaItem(enumValue: Etapa.FOTOS, name: "Fotos", etapaWidget: CheckInTela.new, isDone: false),
    EtapaItem(
        enumValue: Etapa.DESLOCAMENTO,
        name: "Deslocamento",
        etapaWidget: TelaDeslocamento.new,
        isDone: false),
    EtapaItem(
        enumValue: Etapa.CHECKOUT, name: "Check-out", etapaWidget: CheckOutTela.new, isDone: false),
    EtapaItem(
        enumValue: Etapa.CONCLUSAO,
        name: "Conclusão",
        etapaWidget: TelaConclusao.new,
        isDone: false),
    EtapaItem(
        enumValue: Etapa.RESPONSAVEL,
        name: "Responsável",
        etapaWidget: TelaResponsavel.new,
        isDone: false),
  ];

  bool get hasSelectedOs => _selectedOs != null;
  int get osId => _selectedOs!['id'];
  EtapaItem? getEtapa(Etapa etapa) => _etapas.firstWhere((element) => element.enumValue == etapa);

  void setSelectedOs(Map<String, dynamic> selectedOs) {
    _selectedOs = selectedOs;
    _loadEtapas();
  }

  void _loadEtapas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final json = opcs.getString("SelectedOS");
    final os = jsonDecode(json!);
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

    notifyListeners();
  }
}

final selectedOsProvider = ChangeNotifierProvider<SelectedOsModel>((ref) {
  return SelectedOsModel();
});
