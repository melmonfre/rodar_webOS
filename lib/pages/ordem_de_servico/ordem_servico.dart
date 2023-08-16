import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_iniciar_execucao.dart';
import 'package:rodarwebos/widgets/botoes/botao_visita_frustada.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tela_inicial/tela_inicial.dart';

class OrdemServico extends StatefulWidget {
  OrdemServico({Key? key}) : super(key: key);

  @override
  _OrdemServicoState createState() => _OrdemServicoState();
}

class _OrdemServicoState extends State<OrdemServico> {
  int num = 0;

  var element;
  var agendamento; //ok
  var json;
  var os;
  //carro
  var placa; //ok
  var corcarro; //ok
  var chassi; //ok
  var plataforma; //ok
  var modelo; //ok
  var ano; //ok
  var renavam; //ok

  //cliente
  var cliente; //ok
  var empresa; //ok
  var telefone; //ok
  //contatos
  var contatonome; //ok
  var contatoobs; //ok
  //servicos ok
  var servico; //ok
  //equipamentos
  var tiposervico = "";
  var codequip = "";
  var localequip = "";
  // endereço ok
  var local;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    int numero = 0;
    var veiculo = element['veiculo'];
    var empresaveiculo = veiculo['empresa'];
    var fotosnecessarias = empresaveiculo['fotosNecessarias'];
    List<String> referencias = fotosnecessarias.split('\n');
    print("REFERENCIAS: $referencias");
    opcs.setStringList("referencias", referencias);
    placa = veiculo['placa'];
    corcarro = veiculo['cor'];
    chassi = veiculo['chassi'];
    modelo = veiculo['modelo'];
    ano = veiculo['ano'];
    renavam = veiculo['renavan'];
    var pt = veiculo['plataforma'];
    try {
      plataforma = pt['nome'];
    } catch (e) {
      plataforma = "outro";
    }
    var clie = veiculo['cliente'];
    var epss = clie['pessoa'];
    cliente = epss['nome'];
    var emp = epss['empresa'];
    empresa = emp['nome'];
    var tel = emp['telefones'];
    var numtel = tel[0];
    telefone = numtel['numero'];
    var cont = element['contatos'];
    try {
      var contacto = cont[0];
      var contact = contacto["contato"];
      contatonome = contact['nome'];
      contatoobs = contact['observacao'];
    } catch (e) {
      contatonome = "Não informado";
      contatoobs = "";
    }

    var eq = element['equipamentos'];
    eq.forEach((equip) {
      if (equip["tipo"] != null) {
        tiposervico = "$tiposervico \n ${equip["tipo"]}";
      }

      var codigo;

      try {
        if (equip['equipamento'] != null) {
          var equipamento = equip['equipamento'];
          codigo = equipamento["codigo"];
        } else {
          var equipamentoRetirado = equip['equipamentoRetirado'];
          codigo = equipamentoRetirado["codigo"];
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Aviso'),
              content: const Text('Equipamento inválido.'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }

      codequip = "$codequip \n ${codigo}";

      if (equip["localInstalacao"] != null) {
        localequip = "$localequip \n ${equip["localInstalacao"]}";
      }
    });

    List servicos = element['servicos']; // Obtém a lista de serviços do elemento atual
    var serv; // Declaração da variável serv
    servicos.forEach((ser) {
      serv = ser[
          'servico']; // Obtém o valor da chave 'servico' de cada elemento da lista servicos e armazena em serv
    });
    servico = serv['descricao']; // Armazena o valor da chave 'descricao' do objeto serv em servico

    if (tiposervico == "") {
      // Verifica se a variável tiposervico está vazia
      opcs.setString("servico",
          servico); // Define o valor da chave 'servico' no SharedPreferences como servico
    } else {
      opcs.setString("servico",
          tiposervico); // Define o valor da chave 'servico' no SharedPreferences como tiposervico
    }

    var end = element['endereco']; // Obtém o objeto endereco do elemento atual
    var bairro = end['bairro']; // Obtém o valor da chave 'bairro' do objeto end
    var cit = end['cidade']; // Obtém o objeto cidade do objeto end
    var cidade = cit['nome']; // Obtém o valor da chave 'nome' do objeto cit
    var rua = end['rua']; // Obtém o valor da chave 'rua' do objeto end
    var numerocasa = end['numero']; // Obtém o valor da chave 'numero' do objeto end
    local =
        "rua:${rua} numero:${numerocasa}, ${bairro}, ${cidade}"; // Monta a string local com as informações de endereço

    var localtime =
        element['dataInstalacao']; // Obtém o valor da chave 'dataInstalacao' do elemento atual
    var datahora = localtime.split('T'); // Divide a string em data e hora com base no 'T'
    var data = datahora[0].split('-'); // Divide a parte de data em ano, mês e dia
    var hora = datahora[1].split(':'); // Divide a parte de hora em hora, minuto e segundo
    var hr; // Declaração da variável hr
    if (int.parse(hora[0]) - 3 < 0) {
      hr = int.parse(hora[0]) - 3 + 24; // Realiza um ajuste de fuso horário
    } else {
      hr = int.parse(hora[0]) - 3;
    }
    var agend =
        "${data[2]}/${data[1]}/${data[0]} ${hr}:${hora[1]}"; // Formata a data e hora em uma string
    agendamento = agend; // Atribui a string formatada à variável agendamento

    print("agendamento $agendamento"); // Imprime o valor atual de agendamento
    numero++; // Incrementa o valor da variável numero
    print(numero); // Imprime o valor atual de numero

    setState(() {
      num = numero;
    });
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial()),
            );
          },
        ),
        title: Text('Ordem de Serviço'),
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
                  os.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados de Agendamento',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${agendamento}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Cliente',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cliente: ${cliente}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Empresa: ${empresa}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Telefones: ${telefone}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Contatos',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nome: ${contatonome}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Obs: ${contatoobs}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              // -----------------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Veiculo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Placa: ${placa}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cor: ${corcarro}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chassi: ${chassi}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plataforma: ${plataforma}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Modelo: ${modelo}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ano: ${ano}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Renavan: ${renavam}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Serviços',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${servico}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Equipamentos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tipo de Serviço: ${tiposervico}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Código equipamento ${codequip}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Local de instalação: ${localequip}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Endereço',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${local}",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 44.0,
                      child: BotaoVisitaFrustada(),
                    ),
                  ),
                  SizedBox(width: 10.0), // Espaçamento entre os botões
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 44.0,
                      child: BotaoIniciarExecucaoServico(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }
}
