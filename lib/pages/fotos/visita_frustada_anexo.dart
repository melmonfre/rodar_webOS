import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/visita_frustada_deslocamento.dart';
import 'package:rodarwebos/widgets/anexos/anexo_evidencias.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class VisitaFrustadaAnexo extends StatefulWidget {
  @override
  _VisitaFrustadaAnexoState createState() => _VisitaFrustadaAnexoState();
}

class _VisitaFrustadaAnexoState extends State<VisitaFrustadaAnexo> {
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
          title: Text('Visita frustada'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                  titulo: 'Anexar Evidências',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitaFrustadaDeslocamento(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
