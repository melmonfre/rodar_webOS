import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/pages/responsavel/tela_responsavel.dart';
import 'package:rodarwebos/services/conclusao/confirmaostecnicoassinatura.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:rodarwebos/widgets/foto_assinatura/imagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConclusaoDadosAssinatura extends ConsumerStatefulWidget {
  @override
  _TelaConclusaoDadosAssinaturaState createState() =>
      _TelaConclusaoDadosAssinaturaState();
}

class _TelaConclusaoDadosAssinaturaState
    extends ConsumerState<TelaConclusaoDadosAssinatura> {
  salvanocache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var assinatura = opcs.getString("base64assinatura");
    await opcs.setString(buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.CONCLUSAO.key), assinatura ?? "");
    await opcs.setString("assinaturaconfirmacao", assinatura!);
    ref.read(selectedOsProvider).updateEtapasState();
    ref.read(selectedOsProvider).setSelectedOs(null);
  }

  var os;
  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    setState(() {
      os = element['id'];
    });
  }

  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Conclusão'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$os",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Imagem(
                onPressed: () async {
                  await salvanocache();
                  confirmassinatura().enviar();

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TelaResponsavel()),
                  // );

                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
