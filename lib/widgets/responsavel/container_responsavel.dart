import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/widgets/botoes/botao_coletar_assinatura_responsavel.dart';
import 'package:rodarwebos/widgets/botoes/botao_enviar.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class ContainerResponsavel extends StatefulWidget {
  final VoidCallback onPressed;

  const ContainerResponsavel({
    required this.onPressed,
  });

  @override
  _ContainerResponsavelState createState() => _ContainerResponsavelState();
}

class _ContainerResponsavelState extends State<ContainerResponsavel> {
  var variaveis = VariaveisResumo();
  String motivoDivergencia = '';

  String contatoSelecionado = '';
  bool responsavelAusente = false;
  String motivoAusencia = '';

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
                  Text('Nome'),
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
              InputText(labelText: 'Nome'),
              InputText(labelText: 'Email'),
              InputText(labelText: 'Telefone'),
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
                                title: Text('Enviado com sucesso'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Enviado com sucesso'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
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
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

               
