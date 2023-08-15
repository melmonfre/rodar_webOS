import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
import 'package:rodarwebos/services/conclusao/salvareqptecnico.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    opcs.setStringList("EQProcess", []);
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    int numero = 0;
    var veiculo = element['veiculo'];
    var empresaveiculo = veiculo['empresa'];
    var fotosnecessarias = empresaveiculo['fotosNecessarias'];
    List<String> referencias = fotosnecessarias.split('\n');
    print("REFERENCIAS: $referencias");
    opcs.setStringList("referencias", referencias);
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
  String Control = "RETIRADA";
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
  var eqnovodoc;
  var eqveiculodoc;
  List<String>? codigosEq;

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

      codigosEq = EquipamentoVeiculoCodigos;

      if (codigosEq?.length == 1) {
        selecionadoveiculo = codigosEq![0];
      }

      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];
      eqnovodoc = eqp["EquipamentoNovoDocumento"];
      eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];
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
            items: codigosEq?.map((String item) {
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

          SizedBox(height: 8.0),

          SizedBox(height: 8.0),
          BotaoProximo(
            onPressed: () {
              if (situacaoEquipamento != null) {
                // Verifica se a situação do equipamento foi preenchida
                var eqremovid;
                var eqremoviddoc;
                for (int i = 0; i < EquipamentoVeiculoCodigos.length; i++) {
                  if (EquipamentoVeiculoCodigos[i] == selecionadoveiculo) {
                    eqremovid = EquipamentosVeiculoIDs[
                        i]; // Armazena o ID do equipamento removido correspondente ao veículo selecionado
                    eqremoviddoc = eqveiculodoc[i];
                  }
                }
                Map<String, dynamic> equipamentos = {
                  "EquipamentoInstaladoID": "",
                  "EquipamentoInstaladoCodigo": "",
                  "EquipamentoInstaladoDocumento": "",
                  "EquipamentosRemovidoID":
                      eqremovid, // Armazena o ID do equipamento removido
                  "EquipamentoRemovidoCodigo":
                      selecionadoveiculo, // Armazena o código do equipamento removido (veículo selecionado)
                  "EquipamentoRemovidoDocumento": eqremoviddoc,
                  "localInstalacao":
                      localInstalacao, // Armazena o local de instalação selecionado
                  "control": Control,
                };
                getequipamentos().setEquipamento(
                    equipamentos); // Define os equipamentos selecionados no objeto getequipamentos()
                salvareqtec().enviar();
                Navigator.of(context).pop();
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

      if (EquipamentoVeiculoCodigos.length == 1) {
        selecionadoveiculo = EquipamentoVeiculoCodigos[0];
      }

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
            items: EquipamentoVeiculoCodigos.map((item) {
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
                salvareqtec().enviar();
                Navigator.of(context).pop();
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
  var eqnovodoc;
  var eqveiculodoc;
  var Control = "TROCA";
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
      
      if (EquipamentoNovoCodigos.length == 1) {
        selecionadonovo = EquipamentoNovoCodigos[0];
      }

      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);

      if (EquipamentoVeiculoCodigos.length == 1) {
        selecionadoveiculo = EquipamentoVeiculoCodigos[0];
      }
      
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];
      eqnovodoc = eqp["EquipamentoNovoDocumento"];
      eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];
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
                  var eqremoviddoc;
                  for (int i = 0; i < EquipamentoVeiculoCodigos.length; i++) {
                    if (EquipamentoVeiculoCodigos[i] == selecionadoveiculo) {
                      eqremovid = EquipamentosVeiculoIDs[
                          i]; // Armazena o ID do equipamento removido correspondente ao veículo selecionado
                      eqremoviddoc = eqveiculodoc[i];
                    }
                  }
                  var eqnovosid;
                  var eqnovosdoc;
                  for (int i = 0; i < EquipamentoNovoCodigos.length; i++) {
                    if (EquipamentoNovoCodigos[i] == selecionadonovo) {
                      eqnovosid = EquipamentoNovoIDs[i];
                      eqnovosdoc = eqnovodoc[i];
                    }
                  }
                  Map<String, dynamic> equipamentos = {
                    "EquipamentoInstaladoID": eqnovosid,
                    "EquipamentoInstaladoCodigo": selecionadonovo,
                    "EquipamentoInstaladoDocumento": eqnovosdoc,
                    "EquipamentosRemovidoID":
                        eqremovid, // Armazena o ID do equipamento removido
                    "EquipamentoRemovidoCodigo":
                        selecionadoveiculo, // Armazena o código do equipamento removido (veículo selecionado)
                    "EquipamentoRemovidoDocumento": eqremoviddoc,
                    "localInstalacao":
                        localInstalacao, // Armazena o local de instalação selecionado
                    "control": Control,
                  };
                  getequipamentos().setEquipamento(equipamentos);
                  salvareqtec().enviar();
                  Navigator.of(context).pop();
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
  var Control = "INSTALACAO";
  var eqnovodoc;
  var eqveiculodoc;

  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa");
    print(json);
    var eqp = jsonDecode(json!);
    setState(() {
      EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
      EquipamentoNovoCodigos =
          List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
            
      if (EquipamentoNovoCodigos.length == 1) {
        selecionadonovo = EquipamentoNovoCodigos[0];
      }

      AcessoriosID = eqp["AcessoriosID"];
      AcessoriosDescricao = eqp["AcessoriosDescricao"];
      EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
      EquipamentoVeiculoCodigos =
          List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
      localInstalacao = eqp["localInstalacao"];
      stringEquipamento = eqp["stringEquipamento"];
      eqnovodoc = eqp["EquipamentoNovoDocumento"];
      eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];
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
              var eqnovosdoc;
              for (int i = 0; i < EquipamentoNovoCodigos.length; i++) {
                if (EquipamentoNovoCodigos[i] == selecionadonovo) {
                  eqnovosid = EquipamentoNovoIDs[i];
                  eqnovosdoc = eqnovodoc[i];
                }
              }
              Map<String, dynamic> equipamentos = {
                "EquipamentoInstaladoID": eqnovosid,
                "EquipamentoInstaladoCodigo": selecionadonovo,
                "EquipamentoInstaladoDocumento": eqnovosdoc,
                "EquipamentosRemovidoID": "",
                "EquipamentoRemovidoCodigo": "",
                "EquipamentoRemovidoDocumento": "",
                "localInstalacao": localInstalacao,
                "control": Control,
              };
              getequipamentos().setEquipamento(equipamentos);

              if (localInstalacao != null) {
                salvareqtec().enviar();
                Navigator.of(context).pop();
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
