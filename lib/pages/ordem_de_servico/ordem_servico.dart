import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_iniciar_execucao.dart';
import 'package:rodarwebos/widgets/botoes/botao_visita_frustada.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Title extends StatelessWidget {
  const Title(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class Heading extends StatelessWidget {
  const Heading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 3),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Data extends StatelessWidget {
  const Data(this.text, {super.key, this.paddingBottom = 3});

  final String text;
  final double paddingBottom;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: paddingBottom),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  const Separator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10.0),
        Container(
          height: 1.0,
          color: Colors.grey[500],
        ),
        const SizedBox(height: 10.0),
      ],
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
  //equipamentos,
  var tiposervico = "";
  var codequip = "";
  var localequip = "";
  // endereço ok
  var local;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);

    // final oss = VisualizarOrdemServico(element);

    os = element['id'];

    var veiculo = element['veiculo'];
    var empresaveiculo = veiculo['empresa'];
    var fotosnecessarias = empresaveiculo['fotosNecessarias'];

    List<String> referencias = fotosnecessarias.split('\n');

    // print("REFERENCIAS: $referencias");

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
      tiposervico = "$tiposervico \n ${equip["tipo"]}";

      codequip = "$codequip \n ${equip["id"]}";
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
        "$rua N˚$numerocasa, $bairro, $cidade"; // Monta a string local com as informações de endereço

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
        "${data[2]}/${data[1]}/${data[0]} $hr:${hora[1]}"; // Formata a data e hora em uma string
    agendamento = agend; // Atribui a string formatada à variável agendamento

    // trigger rerender
    setState(() {
      num = num + 1;
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
            Navigator.pop(context);
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
              Title(os.toString()),
              const Heading("Dados de Agendamento"),
              Data("$agendamento"),
              const Separator(),
              const Heading('Dados do Cliente'),
              Data('Cliente: $cliente'),
              Data('Empresa: $empresa'),
              Data(
                'Telefones: $telefone',
                paddingBottom: 0,
              ),
              const Separator(),
              const Heading('Contatos'),
              Data('Nome: $contatonome'),
              Data(
                'Obs: $contatoobs',
                paddingBottom: 0,
              ),
              const Separator(),
              const Heading('Dados do Veiculo'),
              Data('Placa: $placa'),
              Data('Cor: $corcarro'),
              Data('Chassi: $chassi'),
              Data('Plataforma: $plataforma'),
              Data('Modelo: $modelo'),
              Data('Ano: $ano'),
              Data(
                'Renavan: $renavam',
                paddingBottom: 0,
              ),
              const Separator(),
              const Heading('Serviços'),
              Data(
                "$servico",
                paddingBottom: 0,
              ),
              const Separator(),
              const Heading('Equipamentos'),
              Data('Tipo de Serviço: $tiposervico'),
              Data('Código equipamento $codequip'),
              Data('Local de instalação: $localequip'),
              const Separator(),
              const Heading('Endereco'),
              Data(
                "$local",
                paddingBottom: 0,
              ),
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
