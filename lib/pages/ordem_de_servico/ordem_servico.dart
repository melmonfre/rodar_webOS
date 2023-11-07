import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_iniciar_execucao.dart';
import 'package:rodarwebos/widgets/botoes/botao_visita_frustada.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../tela_inicial/tela_inicial.dart';

class SectionHeading extends StatelessWidget {
  String text;

  SectionHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ContextText extends StatelessWidget {
  String text;

  ContextText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}

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

  List<dynamic> acessorios = [];

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

      if (element["acessorios"] != null) {
        setState(() {
          acessorios = element["acessorios"];

          for (var ac in acessorios!) {
            ac.putIfAbsent("nomeAcessorio", () => ac["acessorio"]["descricao"]);
          }
        });
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Ordem de Serviço'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  os.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              SectionHeading(text: 'Dados de Agendamento'),
              const SizedBox(height: 3.0),
              ContextText("${agendamento}"),
              const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 10.0),
              SectionHeading(text: 'Dados do Cliente'),
              const SizedBox(height: 3.0),
              ContextText('Cliente: ${cliente}'),
              const SizedBox(height: 3.0),
              ContextText('Empresa: ${empresa}'),
              const SizedBox(height: 3.0),
              ContextText('Telefones: ${telefone}'),
              const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 10.0),
              SectionHeading(text: 'Contatos'),
              const SizedBox(height: 3.0),
              ContextText('Nome: ${contatonome}'),
              const SizedBox(height: 3.0),
              ContextText('Obs: ${contatoobs}'),
              const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 12.0),
              // -----------------------------------------------------------
              SectionHeading(text: 'Dados do Veiculo'),
              const SizedBox(height: 3.0),
              ContextText('Placa: ${placa}'),
              const SizedBox(height: 3.0),
              ContextText('Cor: ${corcarro}'),
              const SizedBox(height: 3.0),
              ContextText('Chassi: ${chassi}'),
              const SizedBox(height: 3.0),
              ContextText('Plataforma: ${plataforma}'),
              const SizedBox(height: 3.0),
              ContextText('Modelo: ${modelo}'),
              const SizedBox(height: 3.0),
              ContextText('Ano: ${ano}'),
              const SizedBox(height: 3.0),
              ContextText('Renavan: ${renavam}'),
              const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 12.0),
              SectionHeading(text: 'Serviços'),
              const SizedBox(height: 3.0),
              ContextText("${servico}"),
              const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 12.0),
              SectionHeading(text: 'Equipamentos'),
              const SizedBox(height: 3.0),
              ContextText('Tipo de Serviço: ${tiposervico}'),
              const SizedBox(height: 3.0),
              ContextText('Código equipamento ${codequip}'),
              const SizedBox(height: 3.0),
              ContextText('Local de instalação: ${localequip}'),

              if (acessorios.isNotEmpty)
                Column(
                  children: [
                    const SizedBox(height: 12.0),
                    Container(
                      height: 1.0,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(height: 12.0),
                    SectionHeading(text: 'Acessórios'),
                    for (final ac in acessorios) Column(
                      children: [
                        ContextText("Acessório: ${ac['nomeAcessorio']}"),
                        ContextText("Qnt.: ${ac['quantidade'].toInt()}"),
                        if (ac['quantidadeRetirada'] != null && ac['quantidadeRetirada'] > 0) ContextText("Qnt. Retirada: ${ac['quantidadeRetirada'].toInt()}"),
                        if (ac['localInstalacao'] != null) ContextText("Local de Instalação: ${ac['localInstalacao']}"),
                        const SizedBox(height: 12,)
                      ],
                    ),
                  ],
                ),

              if (acessorios.isEmpty) const SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              const SizedBox(height: 12.0),
              SectionHeading(text: 'Endereço'),
              const SizedBox(height: 3.0),
              ContextText("${local}"),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 44.0,
                      child: BotaoVisitaFrustada(),
                    ),
                  ),
                  const SizedBox(width: 10.0), // Espaçamento entre os botões
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: 44.0,
                      child: BotaoIniciarExecucaoServico(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }
}
