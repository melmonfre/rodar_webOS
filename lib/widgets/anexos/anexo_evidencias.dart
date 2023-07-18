import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/tirar_foto/camera.dart';

class AnexoEvidencias extends StatefulWidget {
  final String titulo;
  final VoidCallback onPressed;

  const AnexoEvidencias({
    required this.titulo,
    required this.onPressed,
  });

  @override
  _AnexoEvidenciasState createState() => _AnexoEvidenciasState();
}

class _AnexoEvidenciasState extends State<AnexoEvidencias> {

bool fotosInseridas = false;

  void adicionarFoto() {
    // Lógica para adicionar uma foto
    // ...
    // Atualize a variável fotosInseridas para true quando uma foto for adicionada
    setState(() {
      fotosInseridas = true;
    });
  }

void avancarTela() {
    if (fotosInseridas) {
      // Avance para a próxima tela
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDeslocamento(),
        ),
      );
    } else {
      // Exiba um alerta informando ao usuário para inserir pelo menos uma foto
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Alerta'),
            content: Text('Por favor, insira pelo menos uma foto.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.titulo,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              children: [
                Expanded(
                  // Chamada de widget de camera
                  child: CameraButton(),
                ),
              ],
            ),
            
          ),
          BotaoProximo( 
                onPressed: widget.onPressed,
                ),
        ],
      ),
    );
  }
}
