import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/acessorios/container_acessorios.dart';

import 'package:rodarwebos/widgets/acessorios/container_acessorios_instalados.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class Acessorios extends StatefulWidget {
  @override
  _AcessoriosState createState() => _AcessoriosState();
}

class _AcessoriosState extends State<Acessorios> {
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
        title: Text('Acessorios'),
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
              ContainerAcessorios(),
              ContainerAcessoriosInstalados(),
            ],
          ),
        ),
      ),
    );
  }
}
