import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/acessorios/tela_acessorios.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/equipamentos/container_equipamento.dart';
import 'package:rodarwebos/widgets/equipamentos/variaveis_container.dart';

import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Equipamentos extends StatefulWidget {
  @override
  _EquipamentosState createState() => _EquipamentosState();
}

class _EquipamentosState extends State<Equipamentos> {
  var variaveis = VariaveisEquipamentos();

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
              if (control.contains("manutenção")) ContainerManutencao(),
              if (control.contains("retirada")) ContainerRetirada(),
              if (control.contains("instalação")) ContainerInstalacao(),
              if (control.contains("troca")) ContainerTroca(),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerRetirada extends StatefulWidget {
  @override
  State<ContainerRetirada> createState() => _ContainerRetiradaState();
}

class _ContainerRetiradaState extends State<ContainerRetirada> {
  String? situacaoEquipamento;

  var variaveis = VariaveisEquipamentos();

  String localInstalacao = '';

  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();
    return Column(
      children: [
        // Input equipamento
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16,),
        Text(
                'Situação do equipamento - RETIRADA TESTE',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text(
                      'OK',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'OK',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Com defeito',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'Com defeito',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (situacaoEquipamento != null &&
                      localInstalacao.isNotEmpty) {
                    variaveis.situacaoEquipamento = situacaoEquipamento!;
                    variaveis.localInstalacao = localInstalacao;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acessorios()),
                    );
                  } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
            }
          },
        )
      ],
    );
  }
}
class ContainerManutencao extends StatefulWidget {
  @override
  State<ContainerManutencao> createState() => _ContainerManutencaoState();
}

class _ContainerManutencaoState extends State<ContainerManutencao> {
  var variaveis = VariaveisEquipamentos();

  String localInstalacao = '';

  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();
    return Column(
      children: [
        // Input equipamento
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação - MANUTENCAO TESTE',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (localInstalacao.isNotEmpty) {
              variaveis.localInstalacao = localInstalacao;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Acessorios()),
              );
            } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
            }
          },
        )
      ],
    );
  }
}

//  TROCA

class ContainerTroca extends StatefulWidget {
  @override
  State<ContainerTroca> createState() => _ContainerTrocaState();
}

class _ContainerTrocaState extends State<ContainerTroca> {
  String? situacaoEquipamento;
  var variaveis = VariaveisEquipamentos();
  String localInstalacao = '';
  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();
    return Column(
      children: [
        // Input equipamento
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16,),
        Text(
                'Situação do equipamento - TROCA TESTE',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Column(
                children: <Widget>[
                  RadioListTile<String>(
                    title: Text(
                      'OK',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'OK',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Com defeito',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    value: 'Com defeito',
                    groupValue: situacaoEquipamento,
                    onChanged: (String? value) {
                      setState(() {
                        situacaoEquipamento = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (situacaoEquipamento != null &&
                      localInstalacao.isNotEmpty) {
                    variaveis.situacaoEquipamento = situacaoEquipamento!;
                    variaveis.localInstalacao = localInstalacao;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Acessorios()),
                    );
                  } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
            }
          },
        )
      ],
    );
  }
}

// INSTALAÇÃO

class ContainerInstalacao extends StatefulWidget {
  @override
  State<ContainerInstalacao> createState() => _ContainerInstalacaoState();
}

class _ContainerInstalacaoState extends State<ContainerInstalacao> {
  var variaveis = VariaveisEquipamentos();
  String localInstalacao = '';
  @override
  Widget build(BuildContext context) {
    List<int> codigosEq = variaveis.codigosEq.cast<int>();
    return Column(
      children: [
        // Input equipamento
        DropdownButton<int>(
          value: variaveis.selectedListItem,
          onChanged: (int? newValue) {
            setState(() {
              variaveis.selectedListItem = newValue;
            });
          },
          items: codigosEq.map((int item) {
            return DropdownMenuItem<int>(
              value: item,
              child: Row(
                children: [
                  Icon(Icons.arrow_right),
                  SizedBox(width: 5.0),
                  Text(item.toString()),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 16.0),
        // Input local de instalação
        Text(
          'Local de instalação - INSTALAÇÃO',
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          decoration: InputDecoration(
            // labelText: 'Local de instalação...',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              localInstalacao = value;
            });
          },
        ),
        SizedBox(height: 8.0),
        BotaoProximo(
          onPressed: () {
            if (localInstalacao.isNotEmpty) {
              variaveis.localInstalacao = localInstalacao;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Acessorios()),
              );
            } else {
              // Exibir uma mensagem de erro informando que todas as respostas devem ser preenchidas
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Erro'),
                    content: Text('Por favor, preencha todas as respostas.'),
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
            }
          },
        )
      ],
    );
  }
}
