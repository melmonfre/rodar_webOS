import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/confirmacao_dados/tela_confirmacao_dados_assinatura.dart';
import 'package:rodarwebos/widgets/botoes/botao_confirmar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaConfirmacaoDados extends StatefulWidget {
  @override
  _TelaConfirmacaoDadosState createState() => _TelaConfirmacaoDadosState();
}

class _TelaConfirmacaoDadosState extends State<TelaConfirmacaoDados> {
  int num = 0;

  var element;
  var agendamento; //ok
  var json;
  var os;
  //carro
  var placa; //ok
  var corcarro; //ok
  var chassi; //ok
  var plataforma; //ok
  var modelo; //ok
  var ano; //ok
  var renavam; //ok

  //cliente
  var cliente; //ok
  var empresa; //ok
  var telefone; //ok
  //contatos
  var contatonome; //ok
  var contatoobs; //ok
  //servicos ok
  var servico; //ok
  //equipamentos
  var tiposervico = "";
  var codequip = "";
  var localequip = "";
  // endereço ok
  var local;

  var motivo = ''; // ok
  var local_inst_equip;

  //var acessorio;
  // var quantidade_acessorio;
  //var quantidade_acessorio_retirado;
  //var local_inst_acessorio;
  var deslocamento; //ok
  var valor_deslocamento; //ok
  var pedagio; //ok
  var hodometro; //ok
  var conclusaotecnicodesc; //ok
  var dataconclusao; //ok
  List checkinsitu = []; //ok
  List checkoutsitu = []; //ok
  List nomeschecklist = [];
  String antesText = 'Antes: ';
  String checklist = '';
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    print(opcs.getKeys());
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    var motivos = opcs.getString("motivositens");
    var mots;
    try {
      mots = jsonDecode(motivos!);
    } catch (e) {
      mots = "";
    }
    List nomesmotivos;
    List itensmotivos;
    try {
      nomesmotivos = mots["nomesmotivos"];
      itensmotivos = mots["itensmotivos"];
      for (int i = 0; i < nomesmotivos.length; i++) {
        if (itensmotivos[i]) {
          motivo = motivo + " ${nomesmotivos[i]}";
        }
      }
    } catch (e) {
      motivo = "";
    }

    os = element['id'];
    int numero = 0;
    var veiculo = element['veiculo'];
    placa = veiculo['placa'];
    corcarro = veiculo['cor'];
    chassi = veiculo['chassi'];
    modelo = veiculo['modelo'];
    var pt = veiculo['plataforma'];
    ano = veiculo['ano'];
    renavam = veiculo['renavan'];
    try {
      plataforma = pt['nome'];
    } catch (e) {
      plataforma = "outro";
    }
    var clie = veiculo['cliente'];
    var epss = clie['pessoa'];
    cliente = epss['nome'];
    var emp = epss['empresa'];
    empresa = emp['nome'];
    var tel = emp['telefones'];
    var numtel = tel[0];
    telefone = numtel['numero'];
    var cont = element['contatos'];
    try {
      var contacto = cont[0];
      var contact = contacto["contato"];
      contatonome = contact['nome'];
      contatoobs = contact['observacao'];
    } catch (e) {
      contatonome = "Não informado";
      contatoobs = "";
    }

    var eq = element['equipamentos'];

    eq.forEach((equip) {
      tiposervico = "$tiposervico \n ${equip["tipo"]}";
      var eqpment = equip['equipamento'];
      try {
        codequip = "$codequip \n ${eqpment["codigo"]}";
      } catch (e) {
        codequip = "";
      }
      if (equip["localInstalacao"] != null) {
        localequip = "$localequip ${equip["localInstalacao"]}";
      }
    });

    var desloc = opcs.getString('dadosdeslocamento');
    var dloc = jsonDecode(desloc!);
    deslocamento = dloc["distanciaPercorrida"];
    valor_deslocamento = dloc["valor"];
    pedagio = dloc["pedagio"];
    var conclus = opcs.getString("conclusaoItens");
    print(conclus);
    var conclusion = jsonDecode(conclus!);
    hodometro = conclusion["hodometro"];
    dataconclusao = conclusion['dataConclusao'];
    conclusaotecnicodesc = conclusion['observacoes'];
    List servicos = element['servicos'];
    var serv;
    servicos.forEach((ser) {
      serv = ser['servico'];
    });
    servico = serv['descricao'];
    if (tiposervico == "") {
      opcs.setString("servico", servico);
    } else {
      opcs.setString("servico", tiposervico);
    }
    var end = element['endereco'];
    var bairro = end['bairro'];
    var cit = end['cidade'];
    var cidade = cit['nome'];
    var rua = end['rua'];
    var numerocasa = end['numero'];
    local = "rua:${rua} numero:${numerocasa}, ${bairro}, ${cidade}";
    var localtime = element['dataInstalacao'];
    var datahora = localtime.split('T');
    var data = datahora[0].split('-');
    var hora = datahora[1].split(':');
    var agend =
        "${data[2]}/${data[1]}/${data[0]} ${int.parse(hora[0]) - 3}:${hora[1]}";
    agendamento = agend;
    print("agendamento $agendamento");
    numero++;
    print(numero);

    var checkin = opcs.getString('checkinitens');
    var checkinitens = jsonDecode(checkin!);
    List itenscheckin = checkinitens['itenscheckin'];

    var checkout = opcs.getString('checkoutitens');
    var checkoutitens = jsonDecode(checkout!);
    nomeschecklist = checkinitens["nomescheckin"];
    List itenscheckout = checkoutitens['itenscheckin'];

    for (int i = 0; i < itenscheckin.length; i++) {
      var checkin = itenscheckin[i];
      var checkout = itenscheckout[i];
      if (checkin == 0) {
        checkinsitu.add("OK");
      } else if (checkin == 1) {
        checkinsitu.add("Com Defeito");
      } else if (checkin == 2) {
        checkinsitu.add("Não Possui");
      }
      if (checkout == 0) {
        checkoutsitu.add("OK");
      } else if (checkout == 1) {
        checkoutsitu.add("Com Defeito");
      } else if (checkout == 2) {
        checkoutsitu.add("Não Possui");
      }
      checklist = checklist +
          "${nomeschecklist[i]}\n${antesText} ${checkinsitu[i]}\nDepois: ${checkoutsitu[i]}\n\n\n";
    }
    itenscheckin.forEach((element) {});
    itenscheckout.forEach((element) {});

    setState(() {
      num = numero;
    });
  }

  @override
  void initState() {
    getdata();
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
            Navigator.pop(context);
          },
        ),
        title: Text('Confirmação de dados'),
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
                  "${os}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 12.0),
              // -----------------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Veiculo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Placa: ${placa}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cor: ${corcarro}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chassi: ${chassi}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plataforma: ${plataforma}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Modelo: ${modelo}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ano: ${ano}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Renavam: ${renavam}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Serviços realizado',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$servico",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Motivo Troca/Manutenção',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$motivo",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Local de instalação',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "$local",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Equipamentos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tipo de Serviço: ${tiposervico}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Código equipamento ${codequip}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Local de instalação: ${localequip}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              //TODO FAZER ACESSORIO
              // SizedBox(height: 12.0),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Acessórios',
              //     style: TextStyle(
              //       fontSize: 15,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 3.0),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Acessório: ${variaveis.acessorio}',
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 3.0),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Qnt: ${variaveis.qtd_acess}',
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 3.0),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Qnt Retirada: ${variaveis.qtd_acess_ret}',
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 3.0),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     'Local de instalação: ${variaveis.local_info_tec}',
              //
              //     style: TextStyle(
              //       fontSize: 14,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 12.0),
              // Container(
              //   height: 1.0,
              //   color: Colors.grey[500],
              // ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Deslocamento',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Deslocamento: ${deslocamento}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Valor do Deslocamento: ${valor_deslocamento}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pedágio: ${pedagio}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hodômetro: ${hodometro}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Conclusão Técnico',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Descrição: ${conclusaotecnicodesc}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 15.0),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'CheckList'.toUpperCase(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
              ),
              SizedBox(height: 30.0),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[800],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    '$checklist',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      letterSpacing: 0.8,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),

              // ================================================
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Data de conclusão',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${dataconclusao}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              BotaoConfirmar(onPressed: () {
                //Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TelaConclusaoDadosAssinatura()),
                );
              }),
              SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }
}
