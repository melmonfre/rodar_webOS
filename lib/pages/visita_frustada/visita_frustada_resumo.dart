import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/fotos/visita_frustada_anexo.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VisitaFrustadaResumo extends StatefulWidget {
  @override
  _VisitaFrustadaResumoState createState() => _VisitaFrustadaResumoState();
}

class _VisitaFrustadaResumoState extends State<VisitaFrustadaResumo> {
  var variaveis = VariaveisResumo();

  int num =0;

  var element;
  var agendamento; //ok
  var tempoespera;
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
    try{
      plataforma = pt['nome'];
    } catch(e){
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
    var contacto;
    try{
      contacto = cont[0];
      var contact = contacto["contato"];
      contatonome = contact['nome'];
      contatoobs = contact['observacao'];
    } catch(e){
      contatonome ="não informado";
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
    var hr;
    if(int.parse(hora[0])-3  <0){
      hr = int.parse(hora[0])-3  + 24;
    } else {
      hr = int.parse(hora[0])-3;
    }
    var agend = "${data[2]}/${data[1]}/${data[0]} ${hr}:${hora[1]}";
    //TODO: fazer calculo do tempo de espera
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
        title: Text('Visita frustada'),
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
                  '${os}',
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
                  '$agendamento',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              //SizedBox(height: 12.0),
              //Container(
             //   height: 1.0,
              //  color: Colors.grey[500],
             // ),
             // SizedBox(height: 12.0),
             // Align(
              //  alignment: Alignment.centerLeft,
              //  child: Text(
                //  'Tempo de espera',
                //  style: TextStyle(
                 //   fontSize: 15,
                  //  fontWeight: FontWeight.bold,
                 // ),
               // ),
              //),
             // SizedBox(height: 3.0),
              //Align(
              //  alignment: Alignment.centerLeft,
               // child: Text(
                //  'Não houve tempo de espera, agendamento marcado para ${variaveis.minutos} minutos',
                //  style: TextStyle(
                //    fontSize: 14,
                //  ),
               // ),
             // ),
             // SizedBox(height: 12.0),
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
                  'Chassis: ${chassi}',
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
                  "$servico",
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
                  '$local',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40.0,
                    child: Center(
                      child: BotaoProximo(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitaFrustadaAnexo()),
                          );
                        },
                      ),
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
