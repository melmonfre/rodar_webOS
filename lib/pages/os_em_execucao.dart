import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
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
  final bool enabled;

  const Etapa(
      {super.key,
      required this.text,
      required this.isDone,
      required this.widget,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: SizedBox(
        width: 800,
        child: GestureDetector(
          onTap: enabled
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => widget()),
                  );
                }
              : null,
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
                if (enabled)
                  isDone
                      ? const Icon(Icons.check, size: 26)
                      : const Icon(Icons.arrow_right_alt, size: 26),
                if (!enabled && isDone)
                  const Icon(Icons.check, size: 26),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OsEmExecucao extends ConsumerStatefulWidget {
  const OsEmExecucao({super.key});

  @override
  ConsumerState<OsEmExecucao> createState() => _OsEmExecucaoState();
}

class _OsEmExecucaoState extends ConsumerState<OsEmExecucao> {
  @override
  void initState() {
    // loadEtapas();
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
        title: Text('Continuar OS ${ref.watch(selectedOsProvider).osId.toString()}'),
      ),
      body: Container(
        child: Column(
          children: [
            ...ref.watch(selectedOsProvider).getEtapas().map((ei) => Etapa(
                  text: ei.name,
                  isDone: ei.isDone,
                  widget: ei.etapaWidget,
                  enabled: ei.enabled,
                ))
          ],
        ),
      ),
    );
  }
}
