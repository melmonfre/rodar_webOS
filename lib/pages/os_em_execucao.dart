import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/pages/check_in/tela_check_in.dart';
import 'package:rodarwebos/pages/check_out/tela_check_out.dart';
import 'package:rodarwebos/pages/conclusao/tela_conclusao.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:rodarwebos/pages/responsavel/tela_responsavel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EtapaItem {
  String name;
  Widget Function() etapaWidget;
  bool isDone;

  EtapaItem({required this.name, required this.etapaWidget, required this.isDone});
}

class Etapa extends StatelessWidget {
  final String text;
  final bool isDone;
  final Widget Function() widget;

  const Etapa({super.key, required this.text, required this.isDone, required this.widget});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widget()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.left,
              ),
              const Spacer(),
              isDone
                  ? const Icon(Icons.check, size: 26)
                  : const Icon(Icons.arrow_right_alt, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class OsEmExecucao extends StatefulWidget {
  const OsEmExecucao({super.key});

  @override
  State<OsEmExecucao> createState() => _OsEmExecucaoState();
}

class _OsEmExecucaoState extends State<OsEmExecucao> {
  List<EtapaItem> etapas = [
    EtapaItem(name: "Check-in", etapaWidget: CheckInTela.new, isDone: true),
    EtapaItem(name: "Equipamentos", etapaWidget: Equipamentos.new, isDone: true),
    EtapaItem(name: "Acessórios", etapaWidget: Acessorios.new, isDone: true),
    EtapaItem(name: "Fotos", etapaWidget: CheckInTela.new, isDone: false),
    EtapaItem(name: "Deslocamento", etapaWidget: TelaDeslocamento.new, isDone: false),
    EtapaItem(name: "Check-out", etapaWidget: CheckOutTela.new, isDone: false),
    EtapaItem(name: "Conclusão", etapaWidget: TelaConclusao.new, isDone: false),
    EtapaItem(name: "Responsável", etapaWidget: TelaResponsavel.new, isDone: false),
  ];

  var idOs;

  void loadEtapas() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final json = opcs.getString("SelectedOS");
    final os = jsonDecode(json!);

    setState(() {
      idOs = os["id"];
    });
  }

  @override
  void initState() {
    loadEtapas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Continuar OS ${(idOs ?? "").toString()}'),
      ),
      body: Container(
        child: Column(
          children: [
            ...etapas.map((ei) => Etapa(
                  text: ei.name,
                  isDone: ei.isDone,
                  widget: ei.etapaWidget,
                ))
          ],
        ),
      ),
    );
  }
}
