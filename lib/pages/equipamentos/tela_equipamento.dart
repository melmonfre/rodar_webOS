import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/equipamentos/variaveis_container.dart';

class Equipamentos extends StatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends State<Equipamentos> {


  var control = ""; // Definindo o tipo de tela - estatico somente para testes
  var json;
  var element;
  var os;
    getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    setState(() {
      control = opcs.getString("servico")!;
    });
    print("CONTROL $control");
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
        title: Text('Equipamentos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.0),
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
              SizedBox(height: 16.0),
              if (control.toLowerCase().contains("manutençao")) ContainerManutencao(),
              if (control.toLowerCase().contains("retirada")) ContainerRetirada(),
              if (control.toLowerCase().contains("instalaçao")) ContainerInstalacao(),
              if (control.toLowerCase().contains("troca")) ContainerTroca(),
            ],
          ),
        ),
      ),
    );
  }
}


class ContainerRetirada extends StatefulWidget {
  @override
  State<ContainerRetirada> createState() => _ContainerRetiradaState();
}

class _ContainerRetiradaState extends State<ContainerRetirada> {
  String? situacaoEquipamento;
  var EquipamentoNovoIDs;
  List<String> EquipamentoNovoCodigos = [];
  var AcessoriosID;
  var AcessoriosDescricao;
  var EquipamentosVeiculoIDs;
  List<String> EquipamentoVeiculoCodigos = [];
  var localInstalacao;
  var stringEquipamento;
  var selecionadonovo;
  var selecionadoveiculo;
  var situequip;
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =  List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];

      //var mapanovo = Map.fromIterables(EquipamentoNovoIDs, EquipamentoNovoCodigos);
      //var mapveiculo = Map.fromIterables(EquipamentosVeiculoIDs, EquipamentoVeiculoCodigos );
    });
  }
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> codigosEq = EquipamentoVeiculoCodigos;
    return Column(
      children: [
        // Input equipamento
        DropdownButton<String>(
          value: selecionadoveiculo,
          onChanged: (String? newValue) {
            setState(() {
              selecionadoveiculo = newValue;
            });
          },
          items: codigosEq.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),

        Text(
                'Situação do equipamento - RETIRADA',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text(
                      'OK',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'OK',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Com defeito',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'Com defeito',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: localInstalacao,
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (situacaoEquipamento != null &&
                      localInstalacao.isNotEmpty) {
              var eqremovid;
              for (int i =0; i< EquipamentoVeiculoCodigos.length; i++) {
                if(EquipamentoVeiculoCodigos[i] == selecionadoveiculo){
                  eqremovid = EquipamentosVeiculoIDs[i];
                }
              }
              Map<String, dynamic> equipamentos = {
                "EquipamentoInstaladoID": "",
                "EquipamentoInstaladoCodigo": "",
                "EquipamentosRemovidoID":eqremovid,
                "EquipamentoRemovidoCodigo": selecionadoveiculo,
                "localInstalacao" : localInstalacao,
              };
              getequipamentos().setEquipamento(equipamentos);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acessorios()),
                    );
                  } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
        )
      ],
    );
  }
}
class ContainerManutencao extends StatefulWidget {
  @override
  State<ContainerManutencao> createState() => _ContainerManutencaoState();
}

class _ContainerManutencaoState extends State<ContainerManutencao> {
  var variaveis = VariaveisEquipamentos();

  String localInstalacao = '';

  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();
    return Column(
      children: [
        // Input equipamento
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação - MANUTENÇÃO',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: localInstalacao,
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (localInstalacao.isNotEmpty) {
              //Todo sincronizar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Acessorios()),
              );
            } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
        )
      ],
    );
  }
}

//  TROCA

class ContainerTroca extends StatefulWidget {
  @override
  State<ContainerTroca> createState() => _ContainerTrocaState();
}

class _ContainerTrocaState extends State<ContainerTroca> {
  String? situacaoEquipamento;
  var EquipamentoNovoIDs;
  List<String> EquipamentoNovoCodigos = [];
  var AcessoriosID;
  var AcessoriosDescricao;
  var EquipamentosVeiculoIDs;
  List<String> EquipamentoVeiculoCodigos = [];
  var localInstalacao;
  var stringEquipamento;
  var selecionadonovo;
  var selecionadoveiculo;
  var situequip;
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =  List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];

      //var mapanovo = Map.fromIterables(EquipamentoNovoIDs, EquipamentoNovoCodigos);
      //var mapveiculo = Map.fromIterables(EquipamentosVeiculoIDs, EquipamentoVeiculoCodigos );
    });
  }
  @override
  void initState() {
    getdata();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        DropdownButton<String>(
          value: selecionadonovo,
          onChanged: (String? newValue) {
            setState(() {
              selecionadonovo = newValue;
            });
          },
          items: EquipamentoNovoCodigos.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text("$item"),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        DropdownButton<String>(
          value: selecionadoveiculo,
          onChanged: (String? newValue) {
            setState(() {
              selecionadoveiculo = newValue;
            });
          },
          items: EquipamentoVeiculoCodigos.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text("$item"),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16,),
        Text(
                'Situação do equipamento - TROCA',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text(
                      'OK',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'OK',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Com defeito',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'Com defeito',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: localInstalacao,
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (situacaoEquipamento != null &&
                      localInstalacao.isNotEmpty) {
              var eqremovid;
              for (int i =0; i< EquipamentoVeiculoCodigos.length; i++) {
                if(EquipamentoVeiculoCodigos[i] == selecionadoveiculo){
                  eqremovid = EquipamentosVeiculoIDs[i];
                }
              }

              var eqnovosid;
              for (int i =0; i< EquipamentoNovoCodigos.length; i++) {
                if(EquipamentoNovoCodigos[i] == selecionadonovo){
                  eqnovosid = EquipamentoNovoIDs[i];
                }
              }
              Map<String, dynamic> equipamentos = {
                "EquipamentoInstaladoID": eqnovosid,
                "EquipamentoInstaladoCodigo": selecionadonovo,
                "EquipamentosRemovidoID":eqremovid,
                "EquipamentoRemovidoCodigo": selecionadoveiculo,
                "localInstalacao" : localInstalacao,
              };
              getequipamentos().setEquipamento(equipamentos);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acessorios()),
                    );
                  } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
        )
      ],
    );
  }
}

// INSTALAÇÃO

class ContainerInstalacao extends StatefulWidget {
  @override
  State<ContainerInstalacao> createState() => _ContainerInstalacaoState();
}

class _ContainerInstalacaoState extends State<ContainerInstalacao> {


  var EquipamentoNovoIDs;
  List<String> EquipamentoNovoCodigos = [];
  var AcessoriosID;
  var AcessoriosDescricao;
  var EquipamentosVeiculoIDs;
  List<String> EquipamentoVeiculoCodigos = [];
  var localInstalacao;
  var stringEquipamento;
  var selecionadonovo;
  var selecionadoveiculo;
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =  List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];
    });
  }
  @override
  void initState() {
    getdata();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        DropdownButton<String>(
          value: selecionadonovo,
          onChanged: (String? newValue) {
            setState(() {
              selecionadonovo = newValue;
            });
          },
          items: EquipamentoNovoCodigos.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação - INSTALAÇÃO',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            hintText: localInstalacao,
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(

          onPressed: () {
            var eqnovosid;
            for (int i =0; i< EquipamentoNovoCodigos.length; i++) {
              if(EquipamentoNovoCodigos[i] == selecionadonovo){
                eqnovosid = EquipamentoNovoIDs[i];
              }
            }
            Map<String, dynamic> equipamentos = {
              "EquipamentoInstaladoID": eqnovosid,
              "EquipamentoInstaladoCodigo": selecionadonovo,
              "EquipamentosRemovidoID":"",
              "EquipamentoRemovidoCodigo": "",
              "localInstalacao" : localInstalacao,
            };
            getequipamentos().setEquipamento(equipamentos);
            if (localInstalacao.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Acessorios()),
              );
            } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
        )
      ],
    );
  }
}
