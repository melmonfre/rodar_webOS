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

  String contatoSelecionado = '';
  bool responsavelAusente = false;
  String motivoAusencia = '';
  String id = '';
  var osid;

  saveoncache() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    Map<String, dynamic> values = {
      "id": id,
      "nome": nome,
      "email": email,
      "telefone": telefone,
      "responsavelAusente": responsavelAusente
    };
    opcs.setString("DadosContato", jsonEncode(values));
  }

  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    var contatos = element['contatos'];

    setState(() {
      osid = element['id'];
      try {
        var contacto = contatos[0];
        id = contacto["id"];
        var contact = contacto["contato"];
        nome = contact['nome'];
        email = contact['email'];
        telefone = contact['telefone'];
      } catch (e) {
        nome = "Não informado";
        email = "";
        telefone = "";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getdata();
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
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Selecione um contato',
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
                    value: 'nome',
                    groupValue: contatoSelecionado,
                    onChanged: (value) {
                      setState(() {
                        contatoSelecionado = value.toString();
                      });
                    },
                  ),
                  Text('$nome'),
                  Radio(
                    value: 'outro',
                    groupValue: contatoSelecionado,
                    onChanged: (value) {
                      setState(() {
                        contatoSelecionado = value.toString();
                      });
                    },
                  ),
                  Text('Outro'),
                ],
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'Contato selecionado',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              if (contatoSelecionado == 'nome')
                Column(
                  children: [
                    InputText(
                      labelText: 'Nome',
                      initialValue:
                          nome, //valor inicial do preenchimento automatico
                      onChanged: (String? value) {
                        if (mounted) {
                          setState(() {
                            nome = value;
                          });
                        }
                      },
                      enabled:
                          false, // Desabilitar o campo preenchido automaticamente
                    ),
                    InputText(
                      labelText: 'Email',
                      initialValue: email,
                      onSubmitted: (value) {
                        if (mounted) {
                          // Verificar se o widget ainda está montado
                          setState(() {
                            email = value;
                            validateEmail(email);
                          });
                        }
                      },
                      onChanged: (String? value) {
                        setState(() {
                          email = value;
                        });
                      },
                      enabled:
                          false, // Desabilitar o campo preenchido automaticamente
                    ),
                    InputText(
                      labelText: 'Telefone',
                      initialValue: telefone,
                      onChanged: (String? value) {
                        if (mounted) {
                          // Verificar se o widget ainda está montado
                          setState(() {
                            telefone = value;
                          });
                        }
                      },
                      enabled:
                          false, // Desabilitar o campo preenchido automaticamente
                    ),
                  ],
                ),
              if (contatoSelecionado == 'outro')
                Column(
                  children: [
                    InputText(
                      labelText: 'Nome',
                      onChanged: (value) {
                        setState(() {
                          nome = value;
                        });
                      },
                    ),
                    InputText(
                      labelText: 'Email',
                      onSubmitted: (value) {
                        setState(() {
                          email = value;
                          validateEmail(email);
                        });
                      },
                    ),
                    InputNumber(
                      labelText: 'Telefone',
                      onChanged: (value) {
                        setState(() {
                          telefone = value;
                        });
                      },
                    ),
                  ],
                ),
              SizedBox(height: 10.0),
              Center(
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
              if (responsavelAusente)
                InputText(labelText: 'Informar motivo da ausência'),
              SizedBox(height: 5.0),
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 17.0),
                child: responsavelAusente
                    ? BotaoEnviar(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Salvo com sucesso'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      saveoncache();
                                      envianot().enviar();
                                      reenvianot().enviar();
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
                        },
                      )
                    : ColetarAssinaturaResponsavel(
                        onPressed: () {
                          if (nome != null ||
                              email != null ||
                              telefone != null) {
                            saveoncache();
                            envianot().enviar();
                            reenvianot().enviar();
                            confirmacaopresencial().enviar();
                            enviardocconfirmacaopresencial().enviar();

                            //concluiOS().concluir(osid);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TelaColetarAssinaturaResponsavel(),
                              ),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Erro'),
                                  content: Text(
                                      'Por favor, preencha todos os campos obrigatórios.'),
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
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função de validação de e-mail
  bool validateEmail(String? email) {
    final emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
    );

    if (email == null || email.isEmpty || !emailRegExp.hasMatch(email)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Text('Por favor, insira um e-mail válido.'),
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
      return false;
    }
    return true;
  }
}
