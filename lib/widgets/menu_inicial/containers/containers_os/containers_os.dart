import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/ordem_servico.dart';
import 'package:rodarwebos/widgets/botoes/botoes_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/variaveis_container_os.dart';

class ContainerOS extends StatefulWidget {
  
  final Widget botao;

  ContainerOS({ required this.botao});

  @override
  _ContainerOSState createState() => _ContainerOSState();
}

class _ContainerOSState extends State<ContainerOS> {
  var variaveis = VariaveisContainersOS();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.0),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width - 20.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9.0),
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
              width: 1.0,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            child: SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'OS: ${variaveis.os[0]}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Agendamento: ${variaveis.agendamento[0]}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Placa: ${variaveis.placa[0]}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Serviço: ${variaveis.servico[0]}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Local: ${variaveis.local[0]}',
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
      ),
    );
  }
}
