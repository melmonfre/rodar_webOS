import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
import 'package:rodarwebos/services/conclusao/salvareqptecnico.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../fotos/telas_fotos/foto_hodometro.dart';

class FormFieldLabel extends StatelessWidget {
  final String text;

  const FormFieldLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class InstalacaoState {
  EquipamentosChangeNotifier notifierInstance;

  InstalacaoState(this.notifierInstance);

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

  bool isValid() {
    return localInstalacao != null;
  }

  Map<String, dynamic> getEquipamento() {
    var eqnovosid;
    var eqnovosdoc;
    for (int i = 0; i < EquipamentoNovoCodigos.length; i++) {
      if (EquipamentoNovoCodigos[i] == selecionadonovo) {
        eqnovosid = EquipamentoNovoIDs[i];
        eqnovosdoc = eqnovodoc[i];
      }
    }
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": eqnovosid,
      "EquipamentoInstaladoCodigo": selecionadonovo,
      "EquipamentoInstaladoDocumento": eqnovosdoc,
      "EquipamentosRemovidoID": "",
      "EquipamentoRemovidoCodigo": "",
      "EquipamentoRemovidoDocumento": "",
      "localInstalacao": localInstalacao,
      "control": Control,
    };

    return equipamento;
  }

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa");
    print(json);
    var eqp = jsonDecode(json!);
    EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
    EquipamentoNovoCodigos = List<String>.from(eqp["EquipamentoNovoCodigos"] as List);

    if (EquipamentoNovoCodigos.length == 1) {
      selecionadonovo = EquipamentoNovoCodigos[0];
    }

    AcessoriosID = eqp["AcessoriosID"];
    AcessoriosDescricao = eqp["AcessoriosDescricao"];
    EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
    EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);
    localInstalacao = eqp["localInstalacao"];
    stringEquipamento = eqp["stringEquipamento"];
    eqnovodoc = eqp["EquipamentoNovoDocumento"];
    eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];

    notifierInstance.notifyListeners();
  }
}

class ManutencaoState {
  EquipamentosChangeNotifier notifierInstance;

  ManutencaoState(this.notifierInstance);

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

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);

    EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
    EquipamentoNovoCodigos = List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
    AcessoriosID = eqp["AcessoriosID"];
    AcessoriosDescricao = eqp["AcessoriosDescricao"];
    EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
    EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);

    if (EquipamentoVeiculoCodigos.length == 1) {
      selecionadoveiculo = EquipamentoVeiculoCodigos[0];
    }

    localInstalacao = eqp["localInstalacao"];
    stringEquipamento = eqp["stringEquipamento"];

    notifierInstance.notifyListeners();
  }

  bool isValid() {
    return localInstalacao != null;
  }

  Map<String, dynamic> getEquipamento() {

    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": "",
      "EquipamentoInstaladoCodigo": selecionadoveiculo,
      "EquipamentoInstaladoDocumento": selecionadoveiculo,
      "EquipamentosRemovidoID": "", // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo": "", // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": "",
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": "MANUTENCAO",
    };

    return equipamento;
  }
}

class RetiradaState {
  EquipamentosChangeNotifier instanceNotifier;

  RetiradaState(this.instanceNotifier);

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

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);

    EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
    EquipamentoNovoCodigos = List<String>.from(eqp["EquipamentoNovoCodigos"] as List);
    AcessoriosID = eqp["AcessoriosID"];
    AcessoriosDescricao = eqp["AcessoriosDescricao"];
    EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];

    EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);

    codigosEq = EquipamentoVeiculoCodigos;

    if (codigosEq?.length == 1) {
      selecionadoveiculo = codigosEq![0];
    }

    localInstalacao = eqp["localInstalacao"];
    stringEquipamento = eqp["stringEquipamento"];
    eqnovodoc = eqp["EquipamentoNovoDocumento"];
    eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];

    instanceNotifier.notifyListeners();
  }

  bool isValid() {
    return situacaoEquipamento != null;
  }


  Map<String, dynamic> getEquipamento() {

    final id = EquipamentosVeiculoIDs[EquipamentoVeiculoCodigos.indexOf(selecionadoveiculo)];

    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": "",
      "EquipamentoInstaladoCodigo": "",
      "EquipamentoInstaladoDocumento": "",
      "EquipamentosRemovidoID": id, // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo":
          selecionadoveiculo, // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": "",
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": Control,
    };

    return equipamento;
  }
}

class TrocaState {
  EquipamentosChangeNotifier notifierInstance;

  TrocaState(this.notifierInstance);

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

  bool isValid() {
    return situacaoEquipamento != null && localInstalacao != null;
  }

  Map<String, dynamic> getEquipamento() {
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
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": eqnovosid,
      "EquipamentoInstaladoCodigo": selecionadonovo,
      "EquipamentoInstaladoDocumento": eqnovosdoc,
      "EquipamentosRemovidoID": eqremovid, // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo":
          selecionadoveiculo, // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": eqremoviddoc,
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": Control,
    };

    return equipamento;
  }

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var json = opcs.getString("equipamentos");
    var eqp = jsonDecode(json!);

    EquipamentoNovoIDs = eqp["EquipamentoNovoIDs"];
    EquipamentoNovoCodigos = List<String>.from(eqp["EquipamentoNovoCodigos"] as List);

    if (EquipamentoNovoCodigos.length == 1) {
      selecionadonovo = EquipamentoNovoCodigos[0];
    }

    AcessoriosID = eqp["AcessoriosID"];
    AcessoriosDescricao = eqp["AcessoriosDescricao"];
    EquipamentosVeiculoIDs = eqp["EquipamentosVeiculoIDs"];
    EquipamentoVeiculoCodigos = List<String>.from(eqp["EquipamentoVeiculoCodigos"] as List);

    if (EquipamentoVeiculoCodigos.length == 1) {
      selecionadoveiculo = EquipamentoVeiculoCodigos[0];
    }

    localInstalacao = eqp["localInstalacao"];
    stringEquipamento = eqp["stringEquipamento"];
    eqnovodoc = eqp["EquipamentoNovoDocumento"];
    eqveiculodoc = eqp["EquipamentoVeiculoDocumento"];
    notifierInstance.notifyListeners();
  }
}

class EquipamentosChangeNotifier extends ChangeNotifier {
  InstalacaoState? instalacaoState;
  ManutencaoState? manutencaoState;
  RetiradaState? retiradaState;
  TrocaState? trocaState;

  bool isAllValid() {
    final instalacaoValid = instalacaoState == null || instalacaoState!.isValid();
    final manutencaoValid = manutencaoState == null || manutencaoState!.isValid();
    final retiradaValid = retiradaState == null || retiradaState!.isValid();
    final trocaValid = trocaState == null || trocaState!.isValid();

    return instalacaoValid && manutencaoValid && retiradaValid && trocaValid;
  }
}

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

  irProximo(EquipamentosChangeNotifier state) {
    debugPrint('botao proximo acionado');
    debugPrint('manutencao exists: ${state.manutencaoState != null}');
    debugPrint('retirada exists: ${state.retiradaState != null}');
    debugPrint('troca exists: ${state.trocaState != null}');
    debugPrint('instalacao exists: ${state.instalacaoState != null}');

    List<Map<String, dynamic>> equipamentos = [];

    if (state.manutencaoState != null) {
      equipamentos.add(state.manutencaoState!.getEquipamento());
    }

    if (state.retiradaState != null) {
      equipamentos.add(state.retiradaState!.getEquipamento());
    }

    if (state.trocaState != null) {
      equipamentos.add(state.trocaState!.getEquipamento());
    }

    if (state.instalacaoState != null) {
      equipamentos.add(state.instalacaoState!.getEquipamento());
    }

    // if (equipamentos.length != 0) {
    //   getequipamentos().setEquipamento(jsonEncode(equipamentos) as dynamic);
    // }

    for (final equip in equipamentos) {
      getequipamentos().setEquipamento(equip);
    }

    // equipamentos.forEach((element) {
    //   getequipamentos().setEquipamento(element);
    // });

    Navigator.of(context).pop();

    Navigator.push(
      context,
      // TODO: ROTA Acessorios()
      MaterialPageRoute(builder: (context) => FotoHodometro()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => EquipamentosChangeNotifier(),
        child: Scaffold(
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

                  Consumer<EquipamentosChangeNotifier>(builder: (context, state, child) {
                    return BotaoProximo(onPressed: () {
                      if (state.isAllValid()) {
                        irProximo(state);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Erro'),
                              content: const Text('Por favor, preencha todas as respostas.'),
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
                      }
                    });
                  })
                ],
              ),
            ),
          ),
        ));
  }
}

class ContainerRetirada extends StatefulWidget {
  @override
  State<ContainerRetirada> createState() => _ContainerRetiradaState();
}

class _ContainerRetiradaState extends State<ContainerRetirada> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);
    var state = wholeState.retiradaState;

    if (wholeState.retiradaState == null) {
      wholeState.retiradaState = RetiradaState(wholeState);
      state = wholeState.retiradaState;
      state?.getData();
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: state?.selecionadoveiculo, // Valor selecionado no dropdown
            onChanged: (String? newValue) {
              setState(() {
                state!.selecionadoveiculo = newValue; // Atualiza o valor selecionado no estado
                state.instanceNotifier.notifyListeners();
              });
            },
            items: state?.codigosEq?.map((String item) {
              return DropdownMenuItem<String>(
                value: item, // Valor do item do dropdown
                child: Row(
                  children: [
                    Icon(Icons.arrow_right), // Ícone exibido antes do item do dropdown
                    SizedBox(width: 5.0),
                    Text(item.toString()), // Texto do item do dropdown
                  ],
                ),
              );
            }).toList(),
            hint: Text('Equipamento'), // Texto exibido quando nenhum valor está selecionado
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
                    state?.situacaoEquipamento, // Valor selecionado atualmente no grupo de opções
                onChanged: (String? value) {
                  setState(() {
                    state!.situacaoEquipamento = value;
                    state.instanceNotifier.notifyListeners();
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
                    state?.situacaoEquipamento, // Valor selecionado atualmente no grupo de opções
                onChanged: (String? value) {
                  setState(() {
                    state!.situacaoEquipamento = value;
                    state.instanceNotifier
                        .notifyListeners(); // Atualiza o valor selecionado no estado
                  });
                },
              ),
            ],
          ),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);
    var state = wholeState.manutencaoState;

    if (wholeState.manutencaoState == null) {
      wholeState.manutencaoState = ManutencaoState(wholeState);
      state = wholeState.manutencaoState;
      state?.getData();
    }

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: state?.selecionadoveiculo,
            onChanged: (String? newValue) {
              setState(() {
                state!.selecionadoveiculo = newValue;
                state.notifierInstance.notifyListeners();
              });
            },
            items: state?.EquipamentoVeiculoCodigos.map((item) {
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
                hintText: state?.localInstalacao,
                border: OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  state!.localInstalacao = value;
                  state.notifierInstance.notifyListeners();
                });
              },
              onSubmitted: (value) {
                state!.localInstalacao = value;
                state.notifierInstance.notifyListeners();
              },
            ),
          ),
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
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);
    var state = wholeState.trocaState;

    if (wholeState.trocaState == null) {
      wholeState.trocaState = TrocaState(wholeState);
      state = wholeState.trocaState;
      state?.getData();
    }

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input equipamento
            DropdownButton<String>(
              value: state?.selecionadonovo,
              onChanged: (String? newValue) {
                setState(() {
                  state!.selecionadonovo = newValue;
                  state.notifierInstance.notifyListeners();
                });
              },
              items: state?.EquipamentoNovoCodigos.map((item) {
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
              value: state?.selecionadoveiculo,
              onChanged: (String? newValue) {
                setState(() {
                  state!.selecionadoveiculo = newValue;
                  state.notifierInstance.notifyListeners();
                });
              },
              items: state?.EquipamentoVeiculoCodigos.map((item) {
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
                  groupValue: state?.situacaoEquipamento,
                  onChanged: (String? value) {
                    setState(() {
                      state!.situacaoEquipamento = value;
                      state.notifierInstance.notifyListeners();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text(
                    'Com defeito',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  value: 'Com defeito',
                  groupValue: state?.situacaoEquipamento,
                  onChanged: (String? value) {
                    setState(() {
                      state!.situacaoEquipamento = value;
                      state.notifierInstance.notifyListeners();
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
                  hintText: state?.localInstalacao,
                  border: OutlineInputBorder(),
                ),
                onChanged: (String? value) {
                  setState(() {
                    state!.localInstalacao = value;
                    state.notifierInstance.notifyListeners();
                  });
                },
                onSubmitted: (value) {
                  state!.localInstalacao = value;
                  state.notifierInstance.notifyListeners();
                },
              ),
            ),
            SizedBox(height: 8.0),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);
    var state = wholeState.instalacaoState;

    if (wholeState.instalacaoState == null) {
      wholeState.instalacaoState = InstalacaoState(wholeState);
      state = wholeState.instalacaoState;
      state?.getData();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: state?.selecionadonovo,
            onChanged: (String? newValue) {
              setState(() {
                state!.selecionadonovo = newValue;
                state.notifierInstance.notifyListeners();
              });
            },
            items: state?.EquipamentoNovoCodigos.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Row(
                  children: [
                    // const Icon(Icons.arrow_right),
                    const SizedBox(width: 5.0),
                    Text(item),
                  ],
                ),
              );
            }).toList(),
            hint: const Text('Equipamento'),
          ),
          const SizedBox(height: 16.0),
          // Input local de instalação
          const FormFieldLabel('Local de instalação - INSTALAÇÃO'),
          const SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                hintText: state?.localInstalacao,
                border: const OutlineInputBorder(),
              ),
              onChanged: (String? value) {
                setState(() {
                  state!.localInstalacao = value;
                  state.notifierInstance.notifyListeners();
                });
              },
              onSubmitted: (value) {
                state!.localInstalacao = value;
                state.notifierInstance.notifyListeners();
              },
            ),
          ),
        ],
      ),
    );
  }
}
