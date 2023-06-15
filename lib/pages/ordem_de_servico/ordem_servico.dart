import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botao_iniciar_execucao.dart';
import 'package:rodarwebos/widgets/botoes/botao_visita_frustada.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrdemServico extends StatefulWidget {
  OrdemServico({Key? key})
      : super(key: key);

  @override
  _OrdemServicoState createState() => _OrdemServicoState();
}

class _OrdemServicoState extends State<OrdemServico> {
  int num =0;

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
  var empresa;//ok
  var telefone;//ok
  //contatos
  var contatonome; //ok
  var contatoobs; //ok
  //servicos ok
  var servico;//ok
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
    int numero =0;
        var veiculo = element['veiculo'];
        placa = veiculo['placa'];
        corcarro = veiculo['cor'];
        chassi = veiculo['chassi'];
        modelo = veiculo['modelo'];
        var pt = veiculo['plataforma'];
        ano = veiculo['ano'];
        renavam = veiculo['renavan'];
        plataforma = pt['nome'];
        var clie = veiculo['cliente'];
        var epss = clie['pessoa'];
        cliente = epss['nome'];
        var emp = epss['empresa'];
        empresa = emp['nome'];
        var tel = emp['telefones'];
        var numtel = tel[0];
        telefone = numtel['numero'];
        var cont = element['contatos'];
        try{
          var contacto = cont[0];
          var contact = contacto["contato"];
          contatonome = contact['nome'];
          contatoobs = contact['observacao'];
        } catch(e){
          contatonome ="Não informado";
          contatoobs = "";
        }


        var eq = element['equipamentos'];
        eq.forEach((equip) {
          tiposervico = "$tiposervico ${equip["tipo"] }";

          codequip = "$codequip ${equip["id"]}";
          localequip = "$localequip ${equip["localInstalacao"]}";
        });


        List servicos = element['servicos'];
        var serv;
        servicos.forEach((ser) {
          serv = ser['servico'];
        });
        servico = serv['descricao'];
        if(tiposervico == ""){
          opcs.setString("servico", servico);
        } else {
          opcs.setString("servico", tiposervico);
        }
        var end = element['endereco'];
        var bairro = end['bairro'];
        var cit = end['cidade'];
        var cidade = cit['nome'];
        var rua = end['rua'];
        var numerocasa = end['numero'];
        local = "rua:${rua} numero:${numerocasa}, ${bairro}, ${cidade}";
        var localtime = element['dataInstalacao'];
        var datahora = localtime.split('T');
        var data = datahora[0].split('-');
        var hora = datahora[1].split(':');
        var agend = "${data[2]}/${data[1]}/${data[0]} ${int.parse(hora[0])-3}:${hora[1]}";
        agendamento = agend;
        print("agendamento $agendamento");
        numero++;
        print(numero);
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
            Navigator.pop(context);
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
