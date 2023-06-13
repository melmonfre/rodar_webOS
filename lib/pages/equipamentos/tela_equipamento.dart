import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Equipamentos extends StatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends State<Equipamentos> {
  var variaveis = VariaveisResumo();
  var control; // Definindo o tipo de tela - estatico somente para testes
  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    control = opcs.getString("servico");
    print("CONTROL $control");
  }
  @override
  void initState() {
    getdata();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isManutencao = control == "manutenção";
    bool isRetirada = control == "retirada";
    bool isInstalacao = control == "instalação";
    bool isTroca = control == "troca";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(control),
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
              if (isManutencao) ContainerManutencao(),
              if (isRetirada) ContainerRetirada(),
              if (isInstalacao) ContainerInstalacao(),
              if (isTroca) ContainerTroca(),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerTroca extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Equipamento',
          ),
        ),
        // Input equipamento retirado
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Equipamento Retirado',
          ),
        ),
        // Checkbox situação do equipamento
        Row(
          children: [
            Checkbox(
              value: true, // Valor do checkbox "ok"
              onChanged: (value) {},
            ),
            Text('OK'),
            Checkbox(
              value: false, // Valor do checkbox "com defeito"
              onChanged: (value) {},
            ),
            Text('Com Defeito'),
          ],
        ),
        // Input local de instalação
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Local de Instalação',
          ),
        ),
      ],
    );
  }
}

class ContainerManutencao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Equipamento',
          ),
        ),
        // Input local de instalação
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Local de Instalação',
          ),
        ),
      ],
    );
  }
}

class ContainerRetirada extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Equipamento',
          ),
        ),
        // Checkbox situação do equipamento
        Row(
          children: [
            Checkbox(
              value: true, // Valor do checkbox "ok"
              onChanged: (value) {},
            ),
            Text('OK'),
            Checkbox(
              value: false, // Valor do checkbox "com defeito"
              onChanged: (value) {},
            ),
            Text('Com Defeito'),
          ],
        ),
        // Input local de instalação
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Local de Instalação',
          ),
        ),
      ],
    );
  }
}

class ContainerInstalacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Input equipamento
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Equipamento',
          ),
        ),
        // Input local de instalação
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Local de Instalação',
          ),
        ),
      ],
    );
  }
}
