import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../pages/ordem_de_servico/ordem_servico.dart';
class ContainerOS extends StatefulWidget {
  
  final Widget botao;
  ContainerOS({ required this.botao, Key? key})
      : super(key: key);

  @override
  _ContainerOSState createState() => _ContainerOSState();
}

class _ContainerOSState extends State<ContainerOS> {
  int num =0;
  var empresaid;
  List lista = [];
  List os = [];
  List agendamento= [];
  List placa= [];
  List servico= [];
  List local= [];
  var json;
  setossessao(osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var osselecao;
    String selecionado ='';
    lista.forEach((element) {
      if(osid == element['id']){
        print("ELEMENTO ${element}");
        osselecao=element;
      }
    });
    selecionado = jsonEncode(osselecao);
    opcs.setString("SelectedOS", selecionado);

  }

  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    json = opcs.getString("SessionOS");
    lista = jsonDecode(json);
    int numero =0;
    lista.forEach((element) {
      os.add(element['id']);
      var veiculo = element['veiculo'];
      placa.add( veiculo['placa']);
      List servicos = element['servicos'];
      var serv;
      servicos.forEach((ser) {
        serv = ser['servico'];
        //print("serv $serv");
      });
      servico.add(serv['descricao']);
      var end = element['endereco'];
      var bairro = end['bairro'];
      var cidade = end['cidade'];
      local.add("${cidade['nome']}(${bairro})");

      var localtime = element['dataInstalacao'];
      var datahora = localtime.split('T');
      var data = datahora[0].split('-');
      var hora = datahora[1].split(':');
      var hr = 0;
      if(int.parse(hora[0])-3 <0){
        hr = int.parse(hora[0])-3  + 24;
      } else {
        hr = int.parse(hora[0])-3;
      }
      var agend = "${data[2]}/${data[1]}/${data[0]} ${hr}:${hora[1]}";
      agendamento.add(agend);
      numero++;
      print(numero);
    });
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
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: MediaQuery.of(context).size.width * 0.05,
      vertical: MediaQuery.of(context).size.height * 0.02,
    ),
    child: Container(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: num,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.black12)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: GestureDetector(
                  onTap: () {
                    setossessao(os[index]);
                    print("OS ${os[index]}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrdemServico(),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OS: ${os[index]}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Agendamento: ${agendamento[index]}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Placa: ${placa[index]}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Serviço: ${servico[index]}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Local: ${local[index]}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.botao,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}

}
