import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../pages/ordem_de_servico/ordem_servico.dart';

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
  var json;
  setossessao(osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var osselecao;
    String selecionado = '';
    lista.forEach((element) {
      if (osid == element['id']) {
        print("ELEMENTO ${element}");
        osselecao = element;
      }
    });
    selecionado = jsonEncode(osselecao);
    opcs.setString("SelectedOS", selecionado);
  }

  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences
        .getInstance(); // Obtém uma instância do SharedPreferences
    empresaid = opcs.getInt(
        "sessionid"); // Recupera o valor associado à chave "sessionid" e armazena em empresaid
    json = opcs.getString(
        "SessionOS"); // Recupera o valor associado à chave "SessionOS" e armazena em json
    lista = jsonDecode(
        json); // Decodifica a string json em um objeto Dart e armazena em lista
    int numero = 0; // Inicializa a variável numero com 0

    lista.forEach((element) {
      // Loop através de cada elemento da lista
      os.add(element['id']); // Adiciona o valor da chave 'id' à lista os
      var veiculo =
          element['veiculo']; // Obtém o objeto veiculo do elemento atual
      placa.add(
          veiculo['placa']); // Adiciona o valor da chave 'placa' à lista placa

      List servicos =
          element['servicos']; // Obtém a lista de servicos do elemento atual
      var serv; // Declaração da variável serv
      servicos.forEach((ser) {
        serv = ser[
            'servico']; // Obtém o valor da chave 'servico' de cada elemento da lista servicos
        //print("serv $serv");
      });
      servico.add(serv[
          'descricao']); // Adiciona o valor da chave 'descricao' do objeto serv à lista servico

      var end =
          element['endereco']; // Obtém o objeto endereco do elemento atual
      var bairro =
          end['bairro']; // Obtém o valor da chave 'bairro' do objeto end
      var cidade =
          end['cidade']; // Obtém o valor da chave 'cidade' do objeto end
      local.add(
          "${cidade['nome']}(${bairro})"); // Adiciona uma string formatada à lista local

      var localtime = element[
          'dataInstalacao']; // Obtém o valor da chave 'dataInstalacao' do elemento atual
      var datahora = localtime
          .split('T'); // Divide a string em data e hora com base no 'T'
      var data =
          datahora[0].split('-'); // Divide a parte de data em ano, mês e dia
      var hora = datahora[1]
          .split(':'); // Divide a parte de hora em hora, minuto e segundo
      var hr = 0; // Declaração da variável hr
      if (int.parse(hora[0]) - 3 < 0) {
        hr = int.parse(hora[0]) - 3 + 24; // Realiza um ajuste de fuso horário
      } else {
        hr = int.parse(hora[0]) - 3;
      }
      var agend =
          "${data[2]}/${data[1]}/${data[0]} ${hr}:${hora[1]}"; // Formata a data e hora em uma string
      agendamento.add(agend); // Adiciona a string formatada à lista agendamento

      numero++; // Incrementa o valor da variável numero
      print(numero); // Imprime o valor atual de numero
    });

    setState(() {
      num =
          numero; // Atualiza o valor da variável num com o valor final de numero
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
                      setossessao(os[
                          index]); // Chama a função setossessao() com o valor do elemento atual da lista os
                      print(
                          "OS ${os[index]}"); // Imprime a mensagem "OS" seguida do valor do elemento atual da lista os
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrdemServico(), // Navega para a tela OrdemServico()
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
                                'OS: ${os[index]}', // Exibe o texto "OS:" seguido do valor do elemento atual da lista os
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
