import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/pages/fotos/telas_fotos/foto_instalacao.dart';
import 'package:rodarwebos/widgets/anexos/anexo_evidencias.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

import '../../../services/salvaFotos.dart';

class FotoHodometro extends StatefulWidget {
  @override
  _FotoHodometroState createState() => _FotoHodometroState();
}

class _FotoHodometroState extends State<FotoHodometro> {
  var variaveis = VariaveisResumo();
  List<String> referencias = []; // Adicione uma lista de referências

  int referenciaIndex = 0; // Índice da referência atua

  void proximaTela() {
    if (referenciaIndex < referencias.length - 1) {
      setState(() {
        referenciaIndex++;
      });
    } else {
      // Última tela, redirecione para a próxima página
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaDeslocamento(),
        ),
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
        title: Text('Fotos'),
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
                  variaveis.numero_os.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              _buildTelaReferencia(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTelaReferencia() {
    if (referencias.isNotEmpty && referenciaIndex < referencias.length) {
      String referenciaAtual = referencias[referenciaIndex];
      return Column(
        children: [
          Text(
            referenciaAtual,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          AnexoEvidencias(
            titulo: referenciaAtual,
            onPressed: proximaTela,
          ),
        ],
      );
    } else {
      // Sem referências, retorne a tela original
      return AnexoEvidencias(
        titulo: 'Tirar foto btr',
        onPressed: proximaTela,
      );
    }
  }
}