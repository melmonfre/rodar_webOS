import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/pages/coletar_assinatura_responsavel/tela_coleta_assinatura_responsavel.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/OS/ConcluirOS.dart';
import 'package:rodarwebos/services/conclusao/envianotificacaocontato.dart';
import 'package:rodarwebos/services/conclusao/reenviarconfirmacao.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:rodarwebos/widgets/botoes/botao_coletar_assinatura_responsavel.dart';
import 'package:rodarwebos/widgets/botoes/botao_enviar.dart';
import 'package:rodarwebos/widgets/inputs/input_number.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Sincronizar/sincronizarOffline.dart';
import '../../services/conclusao/confirmacaopresencial.dart';
import '../../services/conclusao/enviardocumentopresencial.dart';

class ContainerResponsavel extends ConsumerStatefulWidget {
  final VoidCallback onPressed;

  const ContainerResponsavel({
    required this.onPressed,
  });

  @override
  _ContainerResponsavelState createState() => _ContainerResponsavelState();
}

class _ContainerResponsavelState extends ConsumerState<ContainerResponsavel> {
  bool? hasAcessorios;
  bool? hasManutencao;
  bool? responsavelIsNotAusente;
  bool hasLoaded = false;

  String motivoDivergencia = '';
  String? nome;
  String? email;
  String? telefone;

  var contatoExistente;

  String contatoSelecionado = '';
  int contatoSelecionadoIndex = -2;

  bool responsavelAusente = false;
  String motivoAusencia = '';
  String id = '';
  var osid;

  List<Map<String, dynamic>> contatos = [];

  criaJson() async {
    syncoff().criarjson(osid);
  }

  saveoncache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var id = contatoSelecionadoIndex < 0 ? "0" : contatos[contatoSelecionadoIndex]["id"].toString();

    Map<String, dynamic> values = {
      "id": id,
      "nome": nome,
      "email": email ?? "",
      "telefone": telefone ?? "",
      "responsavelAusente": responsavelAusente
    };

    await opcs.setString("DadosContato", jsonEncode(values));
    await opcs.setString(buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.RESPONSAVEL.key), jsonEncode(values));
    ref.read(selectedOsProvider).updateEtapasState();
  }

  setContato(int contatoToSelect) {
    setState(() {
      contatoSelecionadoIndex = contatoToSelect;

      if (!contatoToSelect.isNegative) {
        try {
          nome = contatos[contatoToSelect]['nome'];
          telefone = contatos[contatoToSelect]['telefone'];
          email = contatos[contatoToSelect]['email'];
        } catch (e) {
          nome = "";
          telefone = "";
          email = "";
        }
      } else {
        nome = "";
        telefone = "";
        email = "";
      }
    });
  }

  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    var sContatos = element['contatos'];

    hasAcessorios = await getHasAcessorios();
    hasManutencao = await getHasManutencao();
    responsavelIsNotAusente = await getResponsavelIsNotAusente();

    setState(() {
      try {
        sContatos.forEach((contatoItem) {
          var c = contatoItem["contato"];

          contatos.add({
            "id": contatoItem["id"].toString(),
            "nome": c["nome"],
            "email": c["email"],
            "telefone": c["telefone"],
          });
        });

        if (contatos.isEmpty) {
          contatoSelecionadoIndex = -1;
        }
      } catch (e) {
        debugPrint("erro ao listar contatos. ${e}");
      }

      osid = element['id'];
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  bool isValid() {
    bool nomeValido = !(nome == null || nome == "");
    bool emailValido = validateEmail(email);
    bool telefoneValido = true;

    return nomeValido && emailValido && telefoneValido;
  }

  void buttonHandler() async {
    if (isValid()) {
      if (responsavelAusente) {
        enviar();
      } else {
        coletarAssinaturaResponsavel();
      }
    } else {
      if (nome == null || nome == "") {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: const Text('Por favor, preencha todos os campos obrigatórios.'),
              actions: [
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
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: const Text('Por favor, insira um e-mail válido.'),
              actions: [
                TextButton(
                  child: Text('OK'),
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

  void enviar() async {
    await saveoncache();
    ref.read(selectedOsProvider).setSelectedOs(null);
    criaJson();

    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Salvo com sucesso'),
          actions: [
            TextButton(
              onPressed: () {
                // envianot().enviar();
                // reenvianot().enviar();
                confirmacaopresencial().enviar();
                enviardocconfirmacaopresencial().enviar();
                concluiOS().concluir(osid);

                Navigator.of(context).pop(); // fechar dialog

                Future.delayed(Duration.zero, () {
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

                  // if (responsavelAusente == false)
                  //   Navigator.of(context).pop(); // 15 segunda assinatura

                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TelaInicial()),
                      (Route<dynamic> route) => false);

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => TelaInicial(),
                  //   ),
                  // );
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void coletarAssinaturaResponsavel() {
    saveoncache();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaColetarAssinaturaResponsavel(),
      ),
    );
  }

  bool validateEmail(String? email) {
    if (!responsavelAusente) return true;

    final emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );

    if (email == null || email.isEmpty || !emailRegExp.hasMatch(email)) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              const Center(
                child: Text(
                  'Selecione um contato',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 60, left: 60, bottom: 10, top: 10),
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: contatoSelecionadoIndex < -1 ? null : contatoSelecionadoIndex,
                  onChanged: (int? newValue) {
                    setState(() {
                      contatoSelecionadoIndex = newValue ?? -2;

                      if (newValue != null) {
                        setContato(contatoSelecionadoIndex);
                      }
                    });
                  },
                  items: [
                    ...contatos
                        .asMap()
                        .map((key, value) =>
                            MapEntry(key, DropdownMenuItem(value: key, child: Text(value["nome"]))))
                        .values
                        .toList(),
                    const DropdownMenuItem(value: -1, child: Text("Outro")),
                  ],
                  hint: const Text('Contato'),
                ),
              ),
              const SizedBox(height: 10.0),
              const Center(
                child: Text(
                  'Contato selecionado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              if (contatoSelecionadoIndex > -2)
                Column(
                  children: [
                    InputText(
                      key: Key("$contatoSelecionadoIndex@nome"),
                      labelText: 'Nome *',
                      initialValue: nome,
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            nome = value;
                          });
                        }
                      },
                      enabled: !(contatoSelecionadoIndex > -1),
                    ),
                    InputText(
                      key: Key("$contatoSelecionadoIndex@email"),
                      labelText: 'Email ${responsavelAusente ? '*' : ''}',
                      initialValue: email,
                      onChanged: (String? value) {
                        setState(() {
                          email = value;
                        });
                      },
                      enabled: !(contatoSelecionadoIndex > -1),
                    ),
                    InputText(
                      key: Key("$contatoSelecionadoIndex@telefone"),
                      labelText: 'Telefone',
                      initialValue: telefone,
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            telefone = value;
                          });
                        }
                      },
                      enabled: !(contatoSelecionadoIndex > -1),
                    ),
                  ],
                ),
              const SizedBox(height: 10.0),
              const Center(
                child: Text(
                  'Responsável ausente?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: true,
                    groupValue: responsavelAusente,
                    onChanged: (value) {
                      setState(() {
                        responsavelAusente = value as bool;
                      });
                    },
                  ),
                  Text('Sim'),
                  Radio(
                    value: false,
                    groupValue: responsavelAusente,
                    onChanged: (value) {
                      setState(() {
                        responsavelAusente = value as bool;
                      });
                    },
                  ),
                  Text('Não'),
                ],
              ),
              if (responsavelAusente) InputText(labelText: 'Informar motivo da ausência'),
              SizedBox(height: 5.0),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 17.0),
                child: responsavelAusente
                    ? BotaoEnviar(onPressed: buttonHandler)
                    : ColetarAssinaturaResponsavel(onPressed: buttonHandler),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
