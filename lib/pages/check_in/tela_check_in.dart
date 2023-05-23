import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_in/variaveis_options.dart';
import 'package:rodarwebos/pages/equipamentos/tela_equipamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/check_in/container_check_in.dart';
import 'package:rodarwebos/widgets/check_in/container_observacao_adicional.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckInTela extends StatefulWidget {
  @override
  _CheckInTelaState createState() => _CheckInTelaState();
}

class _CheckInTelaState extends State<CheckInTela> {
  SelectedOptions selectedOptions =
      SelectedOptions(); // Instância da classe SelectedOptions
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
        title: Text('Check-in'),
      ),
      body: ListView(
        children: [
          ContainerCheckIn(
            title: 'Luzes Painel Instrumento',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.luzesPainelInstrumento =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Ar Condicionado',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.arCondicionado =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Ar quente / Ventilação',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.arQuenteVentilacao =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Rádio / CD / DVD / MP3',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.radioCdDvdMp3 =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Buzinas',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.buzinas =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Teto / Painel / Quebra-sol',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.tetoPainelQuebraSol =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Partida e func. do motor',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.partidaFuncMotor =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Vidros elétricos',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.vidrosEletricos =
                    option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Alarme',
            onOptionSelected: (option) {
              setState(() {
                selectedOptions.alarme = option; // Atualize o valor selecionado
              });
            },
          ),
          ContainerCheckIn(
            title: 'Condições instalação elétrica',
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
              salvaopcoes();
              
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

  Future<void> salvaopcoes() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    setState(() {
      opcs.setString("luzesPainelInstrumento",selectedOptions.luzesPainelInstrumento);
      opcs.setString("arCondicionado",selectedOptions.arCondicionado);
      opcs.setString("arQuenteVentilacao",selectedOptions.arQuenteVentilacao);
      opcs.setString("radioCdDvdMp3",selectedOptions.radioCdDvdMp3);
      opcs.setString("buzinas",selectedOptions.buzinas);
      opcs.setString("tetoPainelQuebraSol",selectedOptions.tetoPainelQuebraSol);
      opcs.setString("partidaFuncMotor", selectedOptions.partidaFuncMotor);
      opcs.setString("vidrosEletricos",selectedOptions.vidrosEletricos);
      opcs.setString("alarme",selectedOptions.alarme);
      opcs.setString("condicoesIntalacaoEletrico",selectedOptions.condicoesIntalacaoEletrico);
    });
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
        MaterialPageRoute(builder: (context) => Equipamentos()),
      );
    }
  }
}


