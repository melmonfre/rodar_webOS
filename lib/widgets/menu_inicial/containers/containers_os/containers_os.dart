import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/services/OS/os_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../pages/ordem_de_servico/ordem_servico.dart';

class ListaOsItem extends StatelessWidget {
  final String numero;
  final String dataAgendamento;
  final String placa;
  final String servico;
  final String local;

  const ListaOsItem(
      {super.key,
      required this.numero,
      required this.dataAgendamento,
      required this.placa,
      required this.servico,
      required this.local});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OS: ${numero}', // Exibe o texto "OS:" seguido do valor do elemento atual da lista os
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Agendamento: ${dataAgendamento}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Placa: ${placa}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Serviço: ${servico}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            'Local: ${local}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Classe responsável por exibir uma lista de elementos [ContainerOS].
///
/// A classe [_ContainerOSState] é um estado associado ao widget [ContainerOS]
/// e é responsável por construir a interface do usuário.
class ContainerOS extends StatefulWidget {
  final Widget botao;
  ContainerOS({required this.botao, Key? key}) : super(key: key);

  @override
  _ContainerOSState createState() => _ContainerOSState();
}

class _ContainerOSState extends State<ContainerOS> {
  int num = 0;
  var empresaid;
  List lista = [];
  List os = [];
  List agendamento = [];
  List placa = [];
  List servico = [];
  List local = [];
  List<dynamic> ordensDeServico = [];
  List<dynamic> ordensDeServicoLista = [];

  var json;

  getData() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final empresaid = opcs.getInt("sessionid");

    final osService = OsService(empresaId: empresaid);

    String? listaGrupo = opcs.getString("listaGrupo");

    switch (listaGrupo) {
      case 'hoje':
        ordensDeServico = await osService.getOsHoje();
        break;
      case 'amanha':
        ordensDeServico = await osService.getOsAmanha();
        break;
      case 'atrasadas':
        ordensDeServico = await osService.getOsAtrasadas();
        break;
      case 'futuras':
        ordensDeServico = await osService.getOsFuturas();
        break;
      default:
        debugPrint('INVALID listaGrupo: ${listaGrupo}');
    }

    for (var os in ordensDeServico) {
      Map<String, dynamic> osLista = {};

      osLista['listaPlaca'] = os['veiculo']['placa'];

      List servicos = os['servicos']; // Obtém a lista de servicos do elemento atual
      var serv; // Declaração da variável serv

      servicos.forEach((ser) {
        serv = ser['servico'];
      });

      osLista['listaServico'] = serv['descricao'];

      var end = os['endereco']; // Obtém o objeto endereco do elemento atual
      var bairro = end['bairro']; // Obtém o valor da chave 'bairro' do objeto end
      var cidade = end['cidade']; // Obtém o valor da chave 'cidade' do objeto end
      osLista['listaLocal'] = ("${cidade['nome']} (${bairro})");

      var localtime = os['dataInstalacao'];
      var datahora = localtime.split('T');
      var data = datahora[0].split('-');
      var hora = datahora[1].split(':');
      var hr = 0;
      if (int.parse(hora[0]) - 3 < 0) {
        hr = int.parse(hora[0]) - 3 + 24; // Realiza um ajuste de fuso horário
      } else {
        hr = int.parse(hora[0]) - 3;
      }
      var agend = "${data[2]}/${data[1]}/${data[0]} ${hr}:${hora[1]}";

      osLista['listaAgendamento'] = agend;
      osLista['listaId'] = os['id'];

      ordensDeServicoLista.add(osLista);
    }

    setState(() {
      ordensDeServicoLista = ordensDeServicoLista;
    });
  }

  setossessao(osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var selectedOs = ordensDeServico.firstWhere((os) => osid == os['id']);

    await opcs.setString("SelectedOS", jsonEncode(selectedOs));
  }

  @override
  void initState() {
    getData();
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
          itemCount: ordensDeServico.length,
          itemBuilder: (BuildContext context, int index) {
            final os = ordensDeServicoLista.elementAt(index);

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
                    onTap: () async {
                      setossessao(os['listaId']);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrdemServico(), // Navega para a tela OrdemServico()
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListaOsItem(
                            numero: os['listaId'].toString(),
                            dataAgendamento: os['listaAgendamento'].toString(),
                            placa: os['listaPlaca'].toString(),
                            servico: os['listaServico'].toString(),
                            local: os['listaLocal'].toString()),
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
