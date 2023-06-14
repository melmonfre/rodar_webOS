import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/pages/deslocamento/visita_frustada_deslocamento.dart';
import 'package:rodarwebos/pages/fotos/telas_fotos/foto_instalacao.dart';
import 'package:rodarwebos/widgets/anexos/anexo_evidencias.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

import '../../../services/salvaFotos.dart';

class FotoEquipamento extends StatefulWidget {
  @override
  _FotoEquipamentoState createState() => _FotoEquipamentoState();
}

class _FotoEquipamentoState extends State<FotoEquipamento> {
  var variaveis = VariaveisResumo();
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
              AnexoEvidencias(
                titulo: 'Tirar foto do equipamento',
                onPressed: () {
                  salvarfotos().save("FotoEquipamento");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaDeslocamento(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
