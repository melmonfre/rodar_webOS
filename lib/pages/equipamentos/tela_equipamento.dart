import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
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

  int id;
  String codigo;
  String documento;
  String localInstalacao;

  InstalacaoState(this.notifierInstance,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  List<String> selectCodigos = [];

  bool isValid() {
    return localInstalacao == "";
  }

  Map<String, dynamic> getEquipamento() {
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": id,
      "EquipamentoInstaladoCodigo": codigo,
      "EquipamentoInstaladoDocumento": documento,
      "EquipamentosRemovidoID": "",
      "EquipamentoRemovidoCodigo": "",
      "EquipamentoRemovidoDocumento": "",
      "localInstalacao": localInstalacao,
      "control": "INSTALACAO",
    };

    return equipamento;
  }

  getData() async {
    selectCodigos = [codigo];
    notifierInstance.notifyListeners();
  }
}

class ManutencaoState {
  EquipamentosChangeNotifier notifierInstance;

  int id;
  String codigo;
  String documento;
  String localInstalacao;

  ManutencaoState(this.notifierInstance,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  String? situacaoEquipamento;

  List<String> selectCodigos = [];

  getData() async {
    selectCodigos = [codigo];
    notifierInstance.notifyListeners();
  }

  bool isValid() {
    return localInstalacao != "";
  }

  Map<String, dynamic> getEquipamento() {
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": id,
      "EquipamentoInstaladoCodigo": codigo,
      "EquipamentoInstaladoDocumento": documento,
      "EquipamentosRemovidoID": "", // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo":
          "", // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": "",
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": "MANUTENCAO",
    };

    return equipamento;
  }
}

class RetiradaState {
  EquipamentosChangeNotifier instanceNotifier;

  int id;
  String codigo;
  String documento;
  String localInstalacao;

  RetiradaState(this.instanceNotifier,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  String? situacaoEquipamento;
  var situequip;

  List<String> selectCodigo = [];

  getData() async {
    selectCodigo = [codigo];
    instanceNotifier.notifyListeners();
  }

  bool isValid() {
    return situacaoEquipamento != null;
  }

  Map<String, dynamic> getEquipamento() {
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": "",
      "EquipamentoInstaladoCodigo": "",
      "EquipamentoInstaladoDocumento": "",
      "EquipamentosRemovidoID": id, // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo":
          codigo, // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": documento,
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": "RETIRADA",
    };

    return equipamento;
  }
}

class TrocaState {
  EquipamentosChangeNotifier notifierInstance;

  int id;
  String codigo;
  String documento;

  int idRemovido;
  String codigoRemovido;
  String documentoRemovido;

  String localInstalacao;

  TrocaState(this.notifierInstance,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.idRemovido,
      required this.codigoRemovido,
      required this.documentoRemovido,
      required this.localInstalacao});

  String? situacaoEquipamento;

  List<String> selectCodigo = [];
  List<String> selectCodigoRemovido = [];

  var situequip;

  bool isValid() {
    return situacaoEquipamento != null && localInstalacao != "";
  }

  Map<String, dynamic> getEquipamento() {
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": id,
      "EquipamentoInstaladoCodigo": codigo,
      "EquipamentoInstaladoDocumento": documento,
      "EquipamentosRemovidoID": idRemovido, // Armazena o ID do equipamento removido
      "EquipamentoRemovidoCodigo":
          codigoRemovido, // Armazena o código do equipamento removido (veículo selecionado)
      "EquipamentoRemovidoDocumento": documentoRemovido,
      "localInstalacao": localInstalacao, // Armazena o local de instalação selecionado
      "control": "TROCA",
    };

    return equipamento;
  }

  getData() async {
    selectCodigo = [codigo];
    selectCodigoRemovido = [codigoRemovido];

    notifierInstance.notifyListeners();
  }
}

class EquipamentosChangeNotifier extends ChangeNotifier {
  List<InstalacaoState> instalacoes = [];
  List<ManutencaoState> manutencoes = [];
  List<RetiradaState> retiradas = [];
  List<TrocaState> trocas = [];

  List<dynamic>? equipamentos;

  loadEquipamentos() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setStringList("EQProcess", []);
    final json = opcs.getString("SelectedOS");
    final element = jsonDecode(json!);

    equipamentos = element["equipamentos"];

    equipamentos?.forEach((equipamento) {
      final tipo = equipamento["tipo"];

      if (tipo == "INSTALACAO") {
        final eqp = equipamento["equipamento"];
        final localInstalacao = equipamento["localInstalacao"] ?? "";
        final state = InstalacaoState(this,
            id: eqp["id"],
            codigo: eqp["codigo"],
            documento: eqp["documento"],
            localInstalacao: localInstalacao);

        state.getData();
        instalacoes.add(state);
      } else if (tipo == "MANUTENCAO") {
        final eqp = equipamento["equipamento"];
        final localInstalacao = equipamento["localInstalacao"] ?? "";
        final state = ManutencaoState(this,
            id: eqp["id"],
            codigo: eqp["codigo"],
            documento: eqp["documento"],
            localInstalacao: localInstalacao);

        state.getData();
        manutencoes.add(state);
      } else if (tipo == "TROCA") {
        final eqp = equipamento["equipamento"];
        final eqpRetirado = equipamento["equipamentoRetirado"];
        final localInstalacao = equipamento["localInstalacao"] ?? "";

        final state = TrocaState(this,
            codigo: eqp["codigo"],
            codigoRemovido: eqpRetirado["codigo"],
            documento: eqp["documento"],
            documentoRemovido: eqpRetirado["documento"],
            id: eqp["id"],
            idRemovido: eqpRetirado["id"],
            localInstalacao: localInstalacao);

        state.getData();
        trocas.add(state);

      } else if (tipo == "RETIRADA") {

        final eqp = equipamento["equipamentoRetirado"];
        final localInstalacao = equipamento["localInstalacao"] ?? "";

        final state = RetiradaState(this,
            id: eqp["id"],
            codigo: eqp["codigo"],
            documento: eqp["documento"],
            localInstalacao: localInstalacao);
        state.getData();

        retiradas.add(state);
      }
    });

    notifyListeners();
  }

  bool isAllValid() {
    final instalacaoValid = instalacoes.every((instalacao) => instalacao.isValid());
    final manutencaoValid = manutencoes.every((manutencao) => manutencao.isValid());
    final retiradaValid = retiradas.every((retirada) => retirada.isValid());
    final trocaValid = trocas.every((troca) => troca.isValid());

    return instalacaoValid && manutencaoValid && retiradaValid && trocaValid;
  }
}

class Equipamentos extends StatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends State<Equipamentos> {
  var control = ""; // Definindo o tipo de tela
  var json;
  var element;
  var os;

  List<dynamic>? equipamentos;

  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setStringList("EQProcess", []);
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    int numero = 0;

    equipamentos = element["equipamentos"];

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
    List<Map<String, dynamic>> equipamentos = [];

    state.manutencoes.forEach((st) {
      equipamentos.add(st.getEquipamento());
    });

    state.trocas.forEach((st) {
      equipamentos.add(st.getEquipamento());
    });

    state.retiradas.forEach((st) {
      equipamentos.add(st.getEquipamento());
    });

    state.instalacoes.forEach((st) {
      equipamentos.add(st.getEquipamento());
    });

    // if (equipamentos.length != 0) {
    //   getequipamentos().setEquipamento(jsonEncode(equipamentos) as dynamic);
    // }

    for (final equip in equipamentos) {
      getequipamentos().setEquipamento(equip);
    }

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
        create: (context) {
          final changeNotifierInstance = EquipamentosChangeNotifier();
          changeNotifierInstance.loadEquipamentos();
          return changeNotifierInstance;
        },
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

                  Consumer<EquipamentosChangeNotifier>(builder: (context, state, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          state.manutencoes.map((e) => ContainerManutencao(state: e)).toList(),
                    );
                  }),

                  Consumer<EquipamentosChangeNotifier>(builder: (context, state, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          state.retiradas.map((e) => ContainerRetirada(state: e)).toList(),
                    );
                  }),// Exibe o widget ContainerRetirada

                  Consumer<EquipamentosChangeNotifier>(builder: (context, state, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                          state.instalacoes.map((e) => ContainerInstalacao(state: e)).toList(),
                    );
                  }),

                  Consumer<EquipamentosChangeNotifier>(builder: (context, state, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: state.trocas.map((e) => ContainerTroca(state: e)).toList(),
                    );
                  }),

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
  RetiradaState state;

  ContainerRetirada({super.key, required this.state});
  
  @override
  State<ContainerRetirada> createState() => _ContainerRetiradaState(state: state);
}

class _ContainerRetiradaState extends State<ContainerRetirada> {

  RetiradaState state;

  _ContainerRetiradaState({required this.state});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: state?.codigo, // Valor selecionado no dropdown
            onChanged: (String? newValue) {
              setState(() {
                state!.codigo = newValue ?? ""; // Atualiza o valor selecionado no estado
                state.instanceNotifier.notifyListeners();
              });
            },
            items: state?.selectCodigo?.map((String item) {
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
  ManutencaoState state;

  ContainerManutencao({super.key, required this.state});

  @override
  State<ContainerManutencao> createState() => _ContainerManutencaoState(state: state);
}

class _ContainerManutencaoState extends State<ContainerManutencao> {
  ManutencaoState state;

  _ContainerManutencaoState({required this.state});

  @override
  void initState() {
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
            value: state?.codigo,
            onChanged: (String? newValue) {
              setState(() {
                state!.codigo = newValue ?? "";
                state.notifierInstance.notifyListeners();
              });
            },
            items: state?.selectCodigos.map((item) {
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
                  state!.localInstalacao = value ?? "";
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
  TrocaState state;
  ContainerTroca({super.key, required this.state});

  @override
  State<ContainerTroca> createState() => _ContainerTrocaState(state: state);
}

class _ContainerTrocaState extends State<ContainerTroca> {
  TrocaState state;

  _ContainerTrocaState({required this.state});

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final wholeState = Provider.of<EquipamentosChangeNotifier>(context);

    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input equipamento
            DropdownButton<String>(
              value: state?.codigo,
              onChanged: (String? newValue) {
                setState(() {
                  state!.codigo = newValue ?? "";
                  state.notifierInstance.notifyListeners();
                });
              },
              items: state?.selectCodigo.map((item) {
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
              value: state?.codigoRemovido,
              onChanged: (String? newValue) {
                setState(() {
                  state!.codigoRemovido = newValue ?? "";
                  state.notifierInstance.notifyListeners();
                });
              },
              items: state?.selectCodigoRemovido.map((item) {
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
                    state?.localInstalacao = value ?? "";
                    state?.notifierInstance.notifyListeners();
                  });
                },
                onSubmitted: (value) {
                  state?.localInstalacao = value;
                  state?.notifierInstance.notifyListeners();
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
  InstalacaoState state;

  ContainerInstalacao({super.key, required this.state});

  @override
  State<ContainerInstalacao> createState() => _ContainerInstalacaoState(state: state);
}

class _ContainerInstalacaoState extends State<ContainerInstalacao> {
  InstalacaoState state;

  _ContainerInstalacaoState({required this.state});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input equipamento
          DropdownButton<String>(
            value: state?.codigo,
            onChanged: (String? newValue) {
              setState(() {
                state!.codigo = newValue ?? "";
                state.notifierInstance.notifyListeners();
              });
            },
            items: state?.selectCodigos.map((String item) {
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
                  state!.localInstalacao = value ?? "";
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
