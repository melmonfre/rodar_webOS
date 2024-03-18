import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/OS/ConcluirOS.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:rodarwebos/widgets/foto_assinatura/imagem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/conclusao/confirmacaopresencial.dart';
import '../../services/conclusao/envianotificacaocontato.dart';
import '../../services/conclusao/enviardocumentopresencial.dart';
import '../../services/conclusao/reenviarconfirmacao.dart';

class TelaColetarAssinaturaResponsavel extends ConsumerStatefulWidget {
  @override
  _TelaColetarAssinaturaResponsavelState createState() =>
      _TelaColetarAssinaturaResponsavelState();
}

class _TelaColetarAssinaturaResponsavelState
    extends ConsumerState<TelaColetarAssinaturaResponsavel> {
  bool? hasAcessorios;
  bool? hasManutencao;
  bool? responsavelIsNotAusente;
  bool hasLoaded = false;

  salvanocache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var assinatura = opcs.getString("base64assinatura");
    await opcs.setString("assinaturaresponsavel", assinatura!);
    await opcs.setString(buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.RESPONSAVEL.key + "@assinaturaResponsavel"), jsonEncode(assinatura ?? ""));
    ref.read(selectedOsProvider).updateEtapasState();
  }

  var os;
  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);

    hasAcessorios = await getHasAcessorios();
    hasManutencao = await getHasManutencao();
    responsavelIsNotAusente = await getResponsavelIsNotAusente();

    setState(() {
      os = element['id'];
      hasLoaded = true;
    });
  }

  concluir() {
    try {
      salvanocache();
    } catch (e) {}
  }

  Future<bool> getHasAcessorios() async {
    try {
      SharedPreferences opcs = await SharedPreferences.getInstance();
      final json = opcs.getString("SelectedOS");
      final element = jsonDecode(json!);
      List<dynamic> acessorios = element["acessorios"];
      return acessorios.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<bool> getHasManutencao() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final json = opcs.getString("SelectedOS");

    final element = jsonDecode(json!);

    bool ismanut = false;
    try {
      List<dynamic> equipamentos = element["equipamentos"];
      equipamentos?.forEach((equipamento) {
        final tipo = equipamento["tipo"];

        if (tipo == "MANUTENCAO") {
          ismanut = true;
        }
      });
    } catch (e) {
      debugPrint("erro isManut: $e");
    }

    return ismanut;
  }

  Future<bool> getResponsavelIsNotAusente() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final contato = opcs.getString("DadosContato");

    try {
      final dadosContato = jsonDecode(contato!);

      if (dadosContato['responsavelAusente'] == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return true;
    }
  }

  Future<void> validafim() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Clicar em "Sim" irá encerrar este formulário, enviar os dados aqui informados e retornar a tela inicial. \n\n '),
                Text('Tem certeza que deseja finalizar?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Sim'),
              onPressed: () async {
                concluiOS().concluir(os);
                // envianot().enviar();
                // reenvianot().enviar();
                confirmacaopresencial().enviar();
                enviardocconfirmacaopresencial().enviar();

                // Navigator.of(context).pop(); // fechar dialog

                // Navigator.of(context).pop(); // 1 overview
                // Navigator.of(context).pop(); // 2 checking
                // Navigator.of(context).pop(); // 3 equipamentos

                // if (hasAcessorios == true) Navigator.of(context).pop(); // 4 acessorios

                // Navigator.of(context).pop(); // 5 foto hodometro
                // Navigator.of(context).pop(); // 6 foto instalacao
                // Navigator.of(context).pop(); // 7 foto equipamento
                // Navigator.of(context).pop(); // 8 deslocamento
                // Navigator.of(context).pop(); // 9 checkout

                // if (hasManutencao == true) Navigator.of(context).pop(); // 10 motivos

                // Navigator.of(context).pop(); // 11 conclusao
                // Navigator.of(context).pop(); // 12 confirmacao dados
                // Navigator.of(context).pop(); // 13 primeira assinatura
                // Navigator.of(context).pop(); // 14 responsavel

                // if (responsavelIsNotAusente == true) Navigator.of(context).pop(); // 15 segunda assinatura

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => TelaInicial()),
                    (Route<dynamic> route) => false);

                ref.read(selectedOsProvider).setSelectedOs(null);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => TelaInicial()),
                // );
              },
            ),
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  finalizar() {
    AlertDialog(
      title: const Text('Concluir'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
                'Clicar em "OK" irá encerrar este formulário, \n enviar os dados aqui informados e \n retornar a tela inicial '),
            Text('Tem certeza que deseja finalizar?'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('sim'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Não'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
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
        title: Text('Coletar assinatura do responsável'),
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
                  salvanocache();
                  validafim();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
