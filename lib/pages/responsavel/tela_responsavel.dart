import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/widgets/foto_assinatura/imagem.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:rodarwebos/widgets/responsavel/container_responsavel.dart';

class TelaResponsavel extends StatefulWidget {
  @override
  _TelaResponsavelState createState() => _TelaResponsavelState();
}

class _TelaResponsavelState extends State<TelaResponsavel> {
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
        title: Text('Responsavel'),
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
              ContainerResponsavel(onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TelaInicial(),
                    ),
                  );
                },)
            ],
          ),
        ),
      ),
    );
  }
}
