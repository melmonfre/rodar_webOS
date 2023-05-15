import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class Equipamentos extends StatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends State<Equipamentos> {
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
                  variaveis.numero_os.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ContainerEquipamento(),
            ],
          ),
        ),
      ),
    );
  }
}
