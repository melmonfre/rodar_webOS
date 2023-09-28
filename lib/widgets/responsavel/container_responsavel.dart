import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/coletar_assinatura_responsavel/tela_coleta_assinatura_responsavel.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/OS/ConcluirOS.dart';
import 'package:rodarwebos/services/conclusao/envianotificacaocontato.dart';
import 'package:rodarwebos/services/conclusao/reenviarconfirmacao.dart';
import 'package:rodarwebos/widgets/botoes/botao_coletar_assinatura_responsavel.dart';
import 'package:rodarwebos/widgets/botoes/botao_enviar.dart';
import 'package:rodarwebos/widgets/inputs/input_number.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Sincronizar/sincronizarOffline.dart';
import '../../services/conclusao/confirmacaopresencial.dart';
import '../../services/conclusao/enviardocumentopresencial.dart';

class ContainerResponsavel extends StatefulWidget {
  final VoidCallback onPressed;

  const ContainerResponsavel({
    required this.onPressed,
  });

  @override
  _ContainerResponsavelState createState() => _ContainerResponsavelState();
}

class _ContainerResponsavelState extends State<ContainerResponsavel> {
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
      "email": email,
      "telefone": telefone,
      "responsavelAusente": responsavelAusente
    };

    await opcs.setString("DadosContato", jsonEncode(values));
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
      if (nome == null || nome == "")  {
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
      } else

      {
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

  void enviar() async {
    saveoncache();
    criaJson();

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

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TelaInicial(),
                  ),
                );
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
                      labelText: 'Email *',
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
