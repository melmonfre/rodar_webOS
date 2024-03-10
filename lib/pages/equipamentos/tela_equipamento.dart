import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
// import 'package:provider/provider.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/services/GetEquipamento.dart';
import 'package:rodarwebos/tools/tools.dart';
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

  int? id;
  String? codigo;
  String? documento;
  String localInstalacao;

  String? codigoOriginal;

  List<dynamic> equipamentosCliente = [];

  InstalacaoState(this.notifierInstance,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  List<String> selectCodigos = [];

  bool isValid() {
    return codigo != null && localInstalacao != "";
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

    if (id == null || codigo != codigoOriginal) {
      try {
        final eqp = equipamentosCliente.firstWhere((eqp) => eqp["codigo"] == codigo);
        equipamento["EquipamentoInstaladoID"] = eqp["id"];
        equipamento["EquipamentoInstaladoCodigo"] = eqp["codigo"];
        equipamento["EquipamentoInstaladoDocumento"] = eqp["documento"];
      } catch (e) {
        debugPrint(e.toString());
        debugPrintStack();
      }
    }

    return equipamento;
  }

  getData() async {
    codigoOriginal = codigo;

    SharedPreferences opcs = await SharedPreferences.getInstance();
    final selectedOs = jsonDecode(opcs.getString("SelectedOS")!);

    dynamic equipamentosClienteStr =
        opcs.getString("${selectedOs["veiculo"]["cliente"]["id"]}@EquipamentosCliente");
    equipamentosCliente = jsonDecode(equipamentosClienteStr);

    equipamentosCliente.forEach((eqp) {
      if (eqp["codigo"] == codigo) return;
      selectCodigos.add(eqp["codigo"]);
    });

    if (codigo != null && codigo != "") {
      selectCodigos.add(codigo ?? "");
    }

    notifierInstance.notifyListeners();
  }
}

class ManutencaoState {
  EquipamentosChangeNotifier notifierInstance;

  int? id;
  String? codigo;
  String? documento;
  String localInstalacao;
  String? codigoOriginal;

  List<dynamic> equipamentosVeiculo = [];

  ManutencaoState(this.notifierInstance,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  String? situacaoEquipamento;

  List<String> selectCodigos = [];

  getData() async {
    codigoOriginal = codigo;

    SharedPreferences opcs = await SharedPreferences.getInstance();
    final selectedOs = jsonDecode(opcs.getString("SelectedOS")!);

    final opcsChave = "${selectedOs["veiculo"]["id"]}@EquipamentosVeiculo";
    dynamic equipamentosVeiculoStr = opcs.getString(opcsChave);

    equipamentosVeiculo = jsonDecode(equipamentosVeiculoStr);

    equipamentosVeiculo.forEach((eqp) {
      if (eqp["codigo"] == codigo) return;
      selectCodigos.add(eqp["codigo"]);
    });

    if (codigo != null && codigo != "") {
      selectCodigos.add(codigo ?? "");
    }

    notifierInstance.notifyListeners();
  }

  bool isValid() {
    return codigo != null && localInstalacao != "";
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
      "control": "MANUTENCAO",
    };

    if (id == null || codigo != codigoOriginal) {
      try {
        final eqp = equipamentosVeiculo.firstWhere((eqp) => eqp["codigo"] == codigo);
        equipamento["EquipamentoInstaladoID"] = eqp["id"];
        equipamento["EquipamentoInstaladoCodigo"] = eqp["codigo"];
        equipamento["EquipamentoInstaladoDocumento"] = eqp["documento"];
      } catch (e) {
        debugPrint(e.toString());
        debugPrintStack();
      }
    }

    return equipamento;
  }
}

class RetiradaState {
  EquipamentosChangeNotifier instanceNotifier;

  int? id;
  String? codigo;
  String? documento;
  String localInstalacao;
  String? codigoOriginal;

  List<dynamic> equipamentosVeiculo = [];

  RetiradaState(this.instanceNotifier,
      {required this.id,
      required this.codigo,
      required this.documento,
      required this.localInstalacao});

  String? situacaoEquipamento;
  var situequip;

  List<String> selectCodigo = [];

  getData() async {
    codigoOriginal = codigo;

    SharedPreferences opcs = await SharedPreferences.getInstance();
    final selectedOs = jsonDecode(opcs.getString("SelectedOS")!);

    var opcsChave = "${selectedOs["veiculo"]["id"]}@EquipamentosVeiculo";
    dynamic equipamentosVeiculoStr = opcs.getString(opcsChave);

    equipamentosVeiculo = jsonDecode(equipamentosVeiculoStr);

    equipamentosVeiculo.forEach((eqp) {
      if (eqp["codigo"] == codigo) return;
      selectCodigo.add(eqp["codigo"]);
    });

    if (codigo != null && codigo != "") {
      selectCodigo.add(codigo ?? "");
    }

    instanceNotifier.notifyListeners();
  }

  bool isValid() {
    return codigo != null && situacaoEquipamento != null;
  }

  Map<String, dynamic> getEquipamento() {
    Map<String, dynamic> equipamento = {
      "EquipamentoInstaladoID": "",
      "EquipamentoInstaladoCodigo": "",
      "EquipamentoInstaladoDocumento": "",
      "EquipamentoRetiradoSituacao": situacaoEquipamento == 'OK',
      "EquipamentosRemovidoID": id,
      "EquipamentoRemovidoCodigo": codigo,
      "EquipamentoRemovidoDocumento": documento,
      "localInstalacao": localInstalacao,
      "control": "RETIRADA",
    };

    if (id == null || codigo != codigoOriginal) {
      try {
        final eqp = equipamentosVeiculo.firstWhere((eqp) => eqp["codigo"] == codigo);
        equipamento["EquipamentosRemovidoID"] = eqp["id"];
        equipamento["EquipamentoRemovidoCodigo"] = eqp["codigo"];
        equipamento["EquipamentoRemovidoDocumento"] = eqp["documento"];
      } catch (e) {
        debugPrint(e.toString());
        debugPrintStack();
      }
    }

    return equipamento;
  }
}

class TrocaState {
  EquipamentosChangeNotifier notifierInstance;

  int? id;
  String? codigo;
  String? documento;
  String? codigoOriginal;

  int? idRemovido;
  String? codigoRemovido;
  String? documentoRemovido;
  String? codigoRemovidoOriginal;

  String localInstalacao;

  List<dynamic> equipamentosCliente = [];
  List<dynamic> equipamentosVeiculo = [];

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
    return codigo != null &&
        codigoRemovido != null &&
        situacaoEquipamento != null &&
        localInstalacao != "";
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

    if (id == null || codigo != codigoOriginal) {
      try {
        final eqp = equipamentosCliente.firstWhere((eqp) => eqp["codigo"] == codigo);
        equipamento["EquipamentoInstaladoID"] = eqp["id"];
        equipamento["EquipamentoInstaladoCodigo"] = eqp["codigo"];
        equipamento["EquipamentoInstaladoDocumento"] = eqp["documento"];
      } catch (e) {
        debugPrint(e.toString());
        debugPrintStack();
      }
    }

    if (idRemovido == null || codigoRemovido != codigoRemovidoOriginal) {
      try {
        final eqp = equipamentosCliente.firstWhere((eqp) => eqp["codigo"] == codigoRemovido);
        equipamento["EquipamentosRemovidoID"] = eqp["id"];
        equipamento["EquipamentoRemovidoCodigo"] = eqp["codigo"];
        equipamento["EquipamentoRemovidoDocumento"] = eqp["documento"];
      } catch (e) {
        debugPrint(e.toString());
        debugPrintStack();
      }
    }

    return equipamento;
  }

  getData() async {
    codigoOriginal = codigo;
    codigoRemovidoOriginal = codigoRemovido;

    SharedPreferences opcs = await SharedPreferences.getInstance();
    final selectedOs = jsonDecode(opcs.getString("SelectedOS")!);

    // codigo - equipamento tecnico
    var opcsChave = "${selectedOs["veiculo"]["cliente"]["id"]}@EquipamentosCliente";
    dynamic equipamentosClienteStr = opcs.getString(opcsChave);

    equipamentosCliente = jsonDecode(equipamentosClienteStr);

    equipamentosCliente.forEach((eqp) {
      if (eqp["codigo"] == codigo) return;
      selectCodigo.add(eqp["codigo"]);
    });

    if (codigo != null && codigo != "") selectCodigo.add(codigo ?? "");
    // ---

    // codigo removido - equipamentos veiculo
    var opcsChaveRemovido = "${selectedOs["veiculo"]["id"]}@EquipamentosVeiculo";
    dynamic equipamentosVeiculoStr = opcs.getString(opcsChaveRemovido);

    equipamentosVeiculo = jsonDecode(equipamentosVeiculoStr);

    equipamentosVeiculo.forEach((eqp) {
      if (eqp["codigo"] == codigoRemovido) return;
      selectCodigoRemovido.add(eqp["codigo"]);
    });

    if (codigoRemovido != null && codigoRemovido != "") {
      selectCodigoRemovido.add(codigoRemovido ?? "");
    }
    // ---

    notifierInstance.notifyListeners();
  }
}

final equipamentosProvider = ChangeNotifierProvider<EquipamentosChangeNotifier>((ref) {
  return EquipamentosChangeNotifier();
});

class EquipamentosChangeNotifier extends ChangeNotifier {
  List<InstalacaoState> instalacoes = [];
  List<ManutencaoState> manutencoes = [];
  List<RetiradaState> retiradas = [];
  List<TrocaState> trocas = [];

  List<dynamic>? equipamentos;

  bool hasDuplicates = true;

  loadEquipamentos() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setStringList("EQProcess", []);
    final json = opcs.getString("SelectedOS");
    final element = jsonDecode(json!);

    instalacoes = [];
    manutencoes = [];
    retiradas = [];
    trocas = [];

    equipamentos = element["equipamentos"];

    equipamentos?.forEach((equipamento) {
      final tipo = equipamento["tipo"];

      if (tipo == "INSTALACAO") {
        final eqp = equipamento["equipamento"] ?? equipamento["equipamentoRetirado"];
        // final eqp = null;
        bool eqpIsNull = eqp == null;
        final localInstalacao = equipamento["localInstalacao"] ?? "";
        final state = InstalacaoState(this,
            id: eqpIsNull ? null : eqp["id"],
            codigo: eqpIsNull ? null : eqp?["codigo"],
            documento: eqpIsNull ? null : eqp?["documento"],
            localInstalacao: localInstalacao);

        state.getData();
        instalacoes.add(state);
      } else if (tipo == "MANUTENCAO") {
        final eqp = equipamento["equipamento"] ?? equipamento["equipamentoRetirado"];
        // final eqp = null;
        final localInstalacao = equipamento["localInstalacao"] ?? "";

        bool eqpIsNull = eqp == null;

        final state = ManutencaoState(this,
            id: eqpIsNull ? null : eqp["id"],
            codigo: eqpIsNull ? null : eqp["codigo"],
            documento: eqpIsNull ? null : eqp["documento"],
            localInstalacao: localInstalacao);

        state.getData();
        manutencoes.add(state);
      } else if (tipo == "TROCA") {
        final eqp = equipamento["equipamento"];
        final eqpRetirado = equipamento["equipamentoRetirado"];

        // final eqp = null;
        // final eqpRetirado = null;

        bool isEqpNull = eqp == null;
        bool isEqpRetiradoNull = eqpRetirado == null;

        final localInstalacao = equipamento["localInstalacao"] ?? "";

        final state = TrocaState(this,
            codigo: isEqpNull ? null : eqp["codigo"],
            codigoRemovido: isEqpRetiradoNull ? null : eqpRetirado["codigo"],
            documento: isEqpNull ? null : eqp["documento"],
            documentoRemovido: isEqpRetiradoNull ? null : eqpRetirado["documento"],
            id: isEqpNull ? null : eqp["id"],
            idRemovido: isEqpRetiradoNull ? null : eqpRetirado["id"],
            localInstalacao: localInstalacao);

        state.getData();
        trocas.add(state);
      } else if (tipo == "RETIRADA") {
        final eqp = equipamento["equipamentoRetirado"];
        // final eqp = null;
        final localInstalacao = equipamento["localInstalacao"] ?? "";
        bool eqpIsNull = eqp == null;

        final state = RetiradaState(this,
            id: eqpIsNull ? null : eqp["id"],
            codigo: eqpIsNull ? null : eqp["codigo"],
            documento: eqpIsNull ? null : eqp["documento"],
            localInstalacao: localInstalacao);
        state.getData();

        retiradas.add(state);
      }
    });

    notifyListeners();
  }

  bool isAllValid() {
    hasDuplicates = false;

    final instalacaoValid = instalacoes.every((instalacao) => instalacao.isValid());
    final manutencaoValid = manutencoes.every((manutencao) => manutencao.isValid());
    final retiradaValid = retiradas.every((retirada) => retirada.isValid());
    final trocaValid = trocas.every((troca) => troca.isValid());

    final allValid = instalacaoValid && manutencaoValid && retiradaValid && trocaValid;

    if (!allValid) return false;

    final instalacaoHasDuplicates =
        instalacoes.length != instalacoes.map((e) => e.codigo).toSet().toList().length;

    final manutencaoHasDuplicates =
        manutencoes.length != manutencoes.map((e) => e.codigo).toSet().toList().length;

    final retiradaHasDuplicates =
        retiradas.length != retiradas.map((e) => e.codigo).toSet().toList().length;

    final trocaHasDuplicates = trocas.length !=
        trocas.map((e) => "${e.codigo}${e.codigoRemovido}").toSet().toList().length;

    hasDuplicates = instalacaoHasDuplicates ||
        manutencaoHasDuplicates ||
        retiradaHasDuplicates ||
        trocaHasDuplicates;

    if (hasDuplicates) return false;

    return true;
  }
}

class Equipamentos extends ConsumerStatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends ConsumerState<Equipamentos> {
  var control = ""; // Definindo o tipo de tela
  var json;
  var element;
  var os;
  bool hasAccessorios = false;

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

    setState(() {
      try {
        List<dynamic> acessorios = element["acessorios"];
        hasAccessorios = acessorios.isNotEmpty;
      } catch (e) {
        hasAccessorios = false;
      }
    });
  }

  @override
  void initState() {
    getdata();
    ref.read(equipamentosProvider).loadEquipamentos();
    super.initState();
  }

  irProximo(EquipamentosChangeNotifier state) async {
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

    SharedPreferences opcs = await SharedPreferences.getInstance();
    
    await opcs.setStringList(
        buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.EQUIPAMENTOS.key),
        equipamentos.map((e) => jsonEncode(e)).toList());

    ref.read(selectedOsProvider).updateEtapasState();

    // Navigator.of(context).pop();

    if (hasAccessorios) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Acessorios()),
      // );
      Navigator.pop(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FotoHodometro()),
      );
    }
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

              Consumer(builder: (context, ref, _) {
                final state = ref.watch(equipamentosProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.manutencoes.map((e) => ContainerManutencao(state: e)).toList(),
                );
              }),

              Consumer(builder: (context, ref, _) {
                final state = ref.watch(equipamentosProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.retiradas.map((e) => ContainerRetirada(state: e)).toList(),
                );
              }), // Exibe o widget ContainerRetirada

              Consumer(builder: (context, ref, _) {
                final state = ref.watch(equipamentosProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.instalacoes.map((e) => ContainerInstalacao(state: e)).toList(),
                );
              }),

              Consumer(builder: (context, ref, _) {
                final state = ref.watch(equipamentosProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.trocas.map((e) => ContainerTroca(state: e)).toList(),
                );
              }),

              Consumer(builder: (context, ref, _) {
                final state = ref.watch(equipamentosProvider);
                return BotaoProximo(onPressed: () {
                  if (state.isAllValid()) {
                    irProximo(state);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Erro'),
                          content: state.hasDuplicates
                              ? const Text(
                                  'Há equipamentos duplicados. Verifique e tente novamente.')
                              : const Text('Por favor, preencha todas as respostas.'),
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
    );
  }
}

class ContainerRetirada extends ConsumerStatefulWidget {
  RetiradaState state;

  ContainerRetirada({super.key, required this.state});

  @override
  ConsumerState<ContainerRetirada> createState() => _ContainerRetiradaState(state: state);
}

class _ContainerRetiradaState extends ConsumerState<ContainerRetirada> {
  RetiradaState state;

  _ContainerRetiradaState({required this.state});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final wholeState = ref.watch(equipamentosProvider);

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

class ContainerManutencao extends ConsumerStatefulWidget {
  ManutencaoState state;

  ContainerManutencao({super.key, required this.state});

  @override
  ConsumerState<ContainerManutencao> createState() => _ContainerManutencaoState(state: state);
}

class _ContainerManutencaoState extends ConsumerState<ContainerManutencao> {
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

class ContainerTroca extends ConsumerStatefulWidget {
  TrocaState state;
  ContainerTroca({super.key, required this.state});

  @override
  ConsumerState<ContainerTroca> createState() => _ContainerTrocaState(state: state);
}

class _ContainerTrocaState extends ConsumerState<ContainerTroca> {
  TrocaState state;

  _ContainerTrocaState({required this.state});

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    // final wholeState = Provider.of<EquipamentosChangeNotifier>(context);

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

class ContainerInstalacao extends ConsumerStatefulWidget {
  InstalacaoState state;

  ContainerInstalacao({super.key, required this.state});

  @override
  ConsumerState<ContainerInstalacao> createState() => _ContainerInstalacaoState(state: state);
}

class _ContainerInstalacaoState extends ConsumerState<ContainerInstalacao> {
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
