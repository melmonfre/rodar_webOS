import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/equipamentos/variaveis_container.dart';
import '../fotos/telas_fotos/foto_hodometro.dart';

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
                  "$os", // Exibe o valor da variável "os"
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0), // Espaçamento vertical
              if (control.toLowerCase().contains(
                  "manut")) // Verifica se a variável "control" contém a palavra "manut" (em minúsculas)
                ContainerManutencao(), // Exibe o widget ContainerManutencao
              if (control.toLowerCase().contains(
                  "retirada")) // Verifica se a variável "control" contém a palavra "retirada" (em minúsculas)
                ContainerRetirada(), // Exibe o widget ContainerRetirada
              if (control.toLowerCase().contains(
                  "instal")) // Verifica se a variável "control" contém a palavra "instal" (em minúsculas)
                ContainerInstalacao(), // Exibe o widget ContainerInstalacao
              if (control.toLowerCase().contains(
                  "troca")) // Verifica se a variável "control" contém a palavra "troca" (em minúsculas)
                ContainerTroca(), // Exibe o widget ContainerTroca
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
  String? localInstalacao;
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
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
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

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: selecionadoveiculo, // Valor selecionado no dropdown
            onChanged: (String? newValue) {
              setState(() {
                selecionadoveiculo =
                    newValue; // Atualiza o valor selecionado no estado
              });
            },
            items: codigosEq.map((String item) {
              return DropdownMenuItem<String>(
                value: item, // Valor do item do dropdown
                child: Row(
                  children: [
                    Icon(Icons
                        .arrow_right), // Ícone exibido antes do item do dropdown
                    SizedBox(width: 5.0),
                    Text(item.toString()), // Texto do item do dropdown
                  ],
                ),
              );
            }).toList(),
            hint: Text(
                'Equipamento'), // Texto exibido quando nenhum valor está selecionado
          ),
          SizedBox(height: 16.0), // Espaçamento vertical

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
                  'OK', // Texto exibido para a opção "OK"
                  style: TextStyle(fontSize: 14.0),
                ),
                value: 'OK', // Valor associado à opção "OK"
                groupValue:
                    situacaoEquipamento, // Valor selecionado atualmente no grupo de opções
                onChanged: (String? value) {
                  setState(() {
                    situacaoEquipamento =
                        value; // Atualiza o valor selecionado no estado
                  });
                },
              ),
              RadioListTile<String>(
                title: Text(
                  'Com defeito', // Texto exibido para a opção "Com defeito"
                  style: TextStyle(fontSize: 14.0),
                ),
                value: 'Com defeito', // Valor associado à opção "Com defeito"
                groupValue:
                    situacaoEquipamento, // Valor selecionado atualmente no grupo de opções
                onChanged: (String? value) {
                  setState(() {
                    situacaoEquipamento =
                        value; // Atualiza o valor selecionado no estado
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
          Container(
            width: double.infinity,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: localInstalacao,
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  localInstalacao = value;
                });
              },
              onSubmitted: (value) {
                localInstalacao = value;
              },
            ),
          ),
          SizedBox(height: 8.0),
          BotaoProximo(
            onPressed: () {
              if (situacaoEquipamento != null && localInstalacao != null) {
                // Verifica se a situação do equipamento e o local de instalação foram selecionados
                var eqremovid;
                for (int i = 0; i < EquipamentoVeiculoCodigos.length; i++) {
                  if (EquipamentoVeiculoCodigos[i] == selecionadoveiculo) {
                    eqremovid = EquipamentosVeiculoIDs[
                        i]; // Armazena o ID do equipamento removido correspondente ao veículo selecionado
                  }
                }
                Map<String, dynamic> equipamentos = {
                  "EquipamentoInstaladoID": "",
                  "EquipamentoInstaladoCodigo": "",
                  "EquipamentosRemovidoID":
                      eqremovid, // Armazena o ID do equipamento removido
                  "EquipamentoRemovidoCodigo":
                      selecionadoveiculo, // Armazena o código do equipamento removido (veículo selecionado)
                  "localInstalacao":
                      localInstalacao, // Armazena o local de instalação selecionado
                };
                getequipamentos().setEquipamento(
                    equipamentos); // Define os equipamentos selecionados no objeto getequipamentos()
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FotoHodometro()), // Navega para a próxima tela (FotoHodometro)
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
      ),
    );
  }
}

class ContainerManutencao extends StatefulWidget {
  @override
  State<ContainerManutencao> createState() => _ContainerManutencaoState();
}

class _ContainerManutencaoState extends State<ContainerManutencao> {
  String? situacaoEquipamento;
  var EquipamentoNovoIDs;
  List<String> EquipamentoNovoCodigos = [];
  var AcessoriosID;
  var AcessoriosDescricao;
  var EquipamentosVeiculoIDs;
  List<String> EquipamentoVeiculoCodigos = [];
  String? localInstalacao;
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
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];
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

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            hint: Text('Equipamento'),
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
          Container(
            width: double.infinity,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: localInstalacao,
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  localInstalacao = value;
                });
              },
              onSubmitted: (value) {
                localInstalacao = value;
              },
            ),
          ),
          SizedBox(height: 8.0),
          BotaoProximo(
            onPressed: () {
              if (localInstalacao != null) {
                Navigator.push(
                  context,
                  //TODO ROTA Acessorios()
                  MaterialPageRoute(builder: (context) => FotoHodometro()),
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
      ),
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
  String? localInstalacao;
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
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
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
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              hint: Text('Equipamento'),
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
              hint: Text('Equipamento Retirado'),
            ),
            SizedBox(
              height: 16,
            ),
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
            Container(
              width: double.infinity,
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: localInstalacao,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    localInstalacao = value;
                  });
                },
                onSubmitted: (value) {
                  localInstalacao = value;
                },
              ),
            ),
            SizedBox(height: 8.0),
            BotaoProximo(
              onPressed: () {
                if (situacaoEquipamento != null && localInstalacao != null) {
                  var eqremovid;
                  for (int i = 0; i < EquipamentoVeiculoCodigos.length; i++) {
                    if (EquipamentoVeiculoCodigos[i] == selecionadoveiculo) {
                      eqremovid = EquipamentosVeiculoIDs[i];
                    }
                  }

                  var eqnovosid;
                  for (int i = 0; i < EquipamentoNovoCodigos.length; i++) {
                    if (EquipamentoNovoCodigos[i] == selecionadonovo) {
                      eqnovosid = EquipamentoNovoIDs[i];
                    }
                  }
                  Map<String, dynamic> equipamentos = {
                    "EquipamentoInstaladoID": eqnovosid,
                    "EquipamentoInstaladoCodigo": selecionadonovo,
                    "EquipamentosRemovidoID": eqremovid,
                    "EquipamentoRemovidoCodigo": selecionadoveiculo,
                    "localInstalacao": localInstalacao,
                  };
                  getequipamentos().setEquipamento(equipamentos);
                  Navigator.push(
                    context,
                    //TODO ROTA Acessorios()
                    MaterialPageRoute(builder: (context) => FotoHodometro()),
                  );
                } else {
                  // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Erro'),
                        content:
                            Text('Por favor, preencha todas as respostas.'),
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
        ));
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
  String? localInstalacao;
  var stringEquipamento;
  var selecionadonovo;
  var selecionadoveiculo;
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
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
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            hint: Text('Equipamento'),
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
          Container(
            width: double.infinity,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: localInstalacao,
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  localInstalacao = value;
                });
              },
              onSubmitted: (value) {
                localInstalacao = value;
              },
            ),
          ),
          SizedBox(height: 8.0),
          BotaoProximo(
            onPressed: () {
              var eqnovosid;
              for (int i = 0; i < EquipamentoNovoCodigos.length; i++) {
                if (EquipamentoNovoCodigos[i] == selecionadonovo) {
                  eqnovosid = EquipamentoNovoIDs[i];
                }
              }
              Map<String, dynamic> equipamentos = {
                "EquipamentoInstaladoID": eqnovosid,
                "EquipamentoInstaladoCodigo": selecionadonovo,
                "EquipamentosRemovidoID": "",
                "EquipamentoRemovidoCodigo": "",
                "localInstalacao": localInstalacao,
              };
              getequipamentos().setEquipamento(equipamentos);
              if (localInstalacao != null) {
                Navigator.push(
                  context,
                  //TODO ROTA Acessorios()
                  MaterialPageRoute(builder: (context) => FotoHodometro()),
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
      ),
    );
  }
}
