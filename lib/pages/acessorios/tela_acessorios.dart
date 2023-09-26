import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/fotos/telas_fotos/foto_hodometro.dart';
import 'package:rodarwebos/widgets/acessorios/container_acessorios.dart';

import 'package:rodarwebos/widgets/acessorios/container_acessorios_instalados.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerWithHeading extends StatelessWidget {
  Widget child;
  String title;

  ContainerWithHeading({super.key, required this.child, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class AcessorioATrocar extends StatelessWidget {
  String localInstalacao;
  double quantidadeAInstalar;
  double quantidadeARetirar;
  String equipamentoNome;

  Function setLocalInstalacao;

  AcessorioATrocar(
      {super.key,
      required this.setLocalInstalacao,
      required this.quantidadeAInstalar,
      required this.quantidadeARetirar,
      required this.equipamentoNome,
      required this.localInstalacao});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        equipamentoNome,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8.0),
      Text(
        'Quantidade a instalar: ${quantidadeAInstalar.toInt()}',
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      const SizedBox(height: 3.0),
      Text(
        'Quantidade a retirar: ${quantidadeARetirar.toInt()}',
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Local de instalação',
          border: OutlineInputBorder(),
        ),
        initialValue: localInstalacao,
        onChanged: (value) {
          setLocalInstalacao(value ?? "");
        },
      )
    ]);
  }
}

class AcessorioAInstalar extends StatelessWidget {
  String localInstalacao;
  double quantidadeAInstalar;
  String equipamentoNome;

  Function setLocalInstalacao;

  AcessorioAInstalar(
      {super.key,
      required this.equipamentoNome,
      required this.quantidadeAInstalar,
      required this.localInstalacao,
      required this.setLocalInstalacao});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        equipamentoNome,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8.0),
      Text(
        'Quantidade a instalar: ${quantidadeAInstalar.toInt()}',
        style: const TextStyle(
          fontSize: 12.0,
        ),
      ),
      const SizedBox(height: 16.0),
      TextFormField(
        decoration: const InputDecoration(
          labelText: 'Local de instalação',
          border: OutlineInputBorder(),
        ),
        initialValue: localInstalacao,
        onChanged: (value) {
          localInstalacao = value;
        },
      )
    ]);
  }
}

class Acessorios extends StatefulWidget {
  @override
  _AcessoriosState createState() => _AcessoriosState();
}

class _AcessoriosState extends State<Acessorios> {
  // var variaveis = VariaveisResumo();

  String os = "";
  List<dynamic> aInstalar = [];
  List<dynamic> aTrocar = [];

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    // opcs.setStringList("EQProcess", []);
    final json = opcs.getString("SelectedOS");
    final element = jsonDecode(json!);

    setState(() {
      os = element['id'].toString();
    });

    List<dynamic> acessorios = element["acessorios"];

    setState(() {
      for (var ac in acessorios) {
        ac.putIfAbsent("nomeAcessorio", () => ac["acessorio"]["descricao"]);

        double qtRetirada = ac["quantidadeRetirada"];

        if (qtRetirada > 0) {
          aTrocar.add(ac);
        } else {
          aInstalar.add(ac);
        }
      }
    });

    debugPrint("load acessorios");
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  bool isAllValid() {
    bool hasLocalInstalacao = true;

    for (var element in aTrocar) {
      if (element["localInstalacao"] == null || element["localInstalacao"] == "") {
        hasLocalInstalacao = false;
      }
    }

    for (var element in aInstalar) {
      if (element["localInstalacao"] == null || element["localInstalacao"] == "") {
        hasLocalInstalacao = false;
      }
    }

    return true;
  }

  saveAcessorios() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final json = opcs.getString("SelectedOS");
    final element = jsonDecode(json!);

    setState(() {
      os = element['id'].toString();
    });

    List<dynamic> acessorios = element["acessorios"];

    List<dynamic> allAcessorios = [aTrocar, aInstalar].expand((e) => {...e}).toList();

    for (var ac in acessorios) {
      final upAcessorio = allAcessorios.firstWhere((e) => e["id"] == ac["id"]);

      ac["localInstalacao"] = upAcessorio?["localInstalacao"] ?? "";
      ac["localInstalacaoTec"] = upAcessorio?["localInstalacao"] ?? "";
    }

    await opcs.setString("${os}@AcessoriosAEnviar", jsonEncode(acessorios));

    debugPrint("acessorios salvos em ${os}@AcessoriosAEnviar");
  }

  irProximo() {
    if (isAllValid()) {
      saveAcessorios();

      Navigator.of(context).pop();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FotoHodometro()),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Por favor, preencha todas os campos.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Acessórios'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  os,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                 ),
                ),
              ),
              if (aTrocar.isNotEmpty)
                ContainerWithHeading(
                    title: "Acessorios para troca: ",
                    child: Column(
                      children: aTrocar
                          .map((ac) => [
                                const SizedBox(height: 16),
                                AcessorioATrocar(
                                    localInstalacao: ac["localInstalacao"] ?? "",
                                    equipamentoNome: ac["nomeAcessorio"],
                                    quantidadeAInstalar: ac["quantidade"] ?? 0.0,
                                    quantidadeARetirar: ac["quantidadeRetirada"] ?? 0.0,
                                    setLocalInstalacao: (String localInstalacao) {
                                      setState(() {
                                        ac["localInstalacao"] = localInstalacao;
                                      });
                                    })
                              ])
                          .expand((element) => element)
                          .toList(),
                    )),
              if (aInstalar.isNotEmpty)
                ContainerWithHeading(
                    title: "Acessorios a instalar: ",
                    child: Column(
                      children: aInstalar
                          .map((ac) => AcessorioAInstalar(
                              localInstalacao: ac["localInstalacao"] ?? "",
                              equipamentoNome: ac["nomeAcessorio"],
                              quantidadeAInstalar: ac["quantidade"] ?? 0.0,
                              setLocalInstalacao: (String localInstalacao) {
                                setState(() {
                                  ac["localInstalacao"] = localInstalacao;
                                });
                              }))
                          .toList(),
                    )),
              const SizedBox(height: 16.0),
              BotaoProximo(onPressed: irProximo)
            ],
          ),
        ),
      ),
    );
  }
}
