import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_in/variaveis_options.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:rodarwebos/pages/motivos/tela_relate_motivos.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/check_in/container_check_in.dart';
import 'package:rodarwebos/widgets/check_in/container_observacao_adicional.dart';
import 'package:rodarwebos/widgets/confirmacao_dados/lista_resumo_estado.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/check_out/container_check_out.dart';

class CheckOutTela extends StatefulWidget {
  @override
  _CheckOutTelaState createState() => _CheckOutTelaState();
}

class _CheckOutTelaState extends State<CheckOutTela> {
  SelectedOptions selectedOptions =
      SelectedOptions(); // Instância da classe SelectedOptions

  Future<void> salvaopcoes() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    setState(() {
      selectedOptions.luzesPainelInstrumento =
          opcs.getString("luzesPainelInstrumento")!;
      selectedOptions.arCondicionado = opcs.getString("arCondicionado")!;
      selectedOptions.arQuenteVentilacao =
          opcs.getString("arQuenteVentilacao")!;
      selectedOptions.radioCdDvdMp3 = opcs.getString("radioCdDvdMp3")!;
      selectedOptions.buzinas = opcs.getString("buzinas")!;
      selectedOptions.tetoPainelQuebraSol =
          opcs.getString("tetoPainelQuebraSol")!;
      selectedOptions.partidaFuncMotor = opcs.getString("partidaFuncMotor")!;
      selectedOptions.vidrosEletricos = opcs.getString("vidrosEletricos")!;
      selectedOptions.alarme = opcs.getString("alarme")!;
      selectedOptions.condicoesIntalacaoEletrico =
          opcs.getString("condicoesIntalacaoEletrico")!;
    });
  }

  @override
  void initState() {
    salvaopcoes();
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
        title: Text('Check-out'),
      ),
      body: ListView(
        children: [
          ContainerCheckOut(
            title: 'Luzes Painel Instrumento',
            value: selectedOptions.luzesPainelInstrumento,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.luzesPainelInstrumento =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Ar Condicionado',
            value: selectedOptions.arCondicionado,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.arCondicionado =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Ar quente / Ventilação',
            value: selectedOptions.arQuenteVentilacao,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.arQuenteVentilacao =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Rádio / CD / DVD / MP3',
            value: selectedOptions.radioCdDvdMp3,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.radioCdDvdMp3 =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Buzinas',
            value: selectedOptions.buzinas,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.buzinas =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Teto / Painel / Quebra-sol',
            value: selectedOptions.tetoPainelQuebraSol,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.tetoPainelQuebraSol =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Partida e func. do motor',
            value: selectedOptions.partidaFuncMotor,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.partidaFuncMotor =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Vidros elétricos',
            value: selectedOptions.vidrosEletricos,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.vidrosEletricos =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Alarme',
            value: selectedOptions.alarme,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.alarme = option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckOut(
            title: 'Condições instalação elétrica',
            value: selectedOptions.condicoesIntalacaoEletrico,
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.condicoesIntalacaoEletrico =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerObservacaoAdicional(
            onPressed: () {
              printSelectedOptions();
              checkNavigation();
            },
          ),
        ],
      ),
    );
  }

  void printSelectedOptions() {
    print(
        'Luzes Painel Instrumento: ${selectedOptions.luzesPainelInstrumento}');
    print('Ar Condicionado: ${selectedOptions.arCondicionado}');
    print('Ar Quente / Ventilação: ${selectedOptions.arQuenteVentilacao}');
    print('Rádio / CD / DVD / MP3: ${selectedOptions.radioCdDvdMp3}');
    print('Buzinas: ${selectedOptions.buzinas}');
    print('Teto / Painel / Quebra-sol: ${selectedOptions.tetoPainelQuebraSol}');
    print('Partida e func. do motor: ${selectedOptions.partidaFuncMotor}');
    print('Vidros elétricos: ${selectedOptions.vidrosEletricos}');
    print('Alarme: ${selectedOptions.alarme}');
    print(
        'Condições instalação elétrica: ${selectedOptions.condicoesIntalacaoEletrico}');
    // Imprima outras opções selecionadas
  }

  void checkNavigation() {
    if (selectedOptions.luzesPainelInstrumento.isEmpty ||
        selectedOptions.arCondicionado.isEmpty ||
        selectedOptions.arQuenteVentilacao.isEmpty ||
        selectedOptions.radioCdDvdMp3.isEmpty ||
        selectedOptions.buzinas.isEmpty ||
        selectedOptions.tetoPainelQuebraSol.isEmpty ||
        selectedOptions.partidaFuncMotor.isEmpty ||
        selectedOptions.vidrosEletricos.isEmpty ||
        selectedOptions.alarme.isEmpty ||
        selectedOptions.condicoesIntalacaoEletrico.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aviso'),
            content: Text(
                'Por favor, preencha todas as opções antes de prosseguir.'),
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RelateMotivo()),
      );
    }
  }
}

// =============================================================
