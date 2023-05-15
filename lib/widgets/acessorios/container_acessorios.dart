import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/acessorios/variaveis_acessorios.dart';

class ContainerAcessorios extends StatefulWidget {
  @override
  _ContainerAcessoriosState createState() => _ContainerAcessoriosState();
}

class _ContainerAcessoriosState extends State<ContainerAcessorios> {
  var variaveis = VariaveisAcessorios();
  String? localInstalacao;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
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
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Acessórios à instalar:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                variaveis.acess[1].toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Quantidade a instalar: 1',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(height: 3.0),
              Text(
                'Quantidade a retirar: 1',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Local de instalação',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    localInstalacao = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
