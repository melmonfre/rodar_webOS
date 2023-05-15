import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/motivos/tela_relate_motivos.dart';
import 'package:rodarwebos/widgets/check_in/container_check_in.dart';
import 'package:rodarwebos/widgets/check_in/container_observacao_adicional.dart';
import 'package:rodarwebos/widgets/check_out/container_check_out.dart';

class CheckOutTela extends StatefulWidget {
  @override
  _CheckOutTelaState createState() => _CheckOutTelaState();
}

class _CheckOutTelaState extends State<CheckOutTela> {
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
        title: Text('Check-Out'),
      ),
      body: ListView(
        children: [
          ContainerCheckOut(title: 'Luzes Painel Instrumento'),
          ContainerCheckOut(title: 'Ar Condicionado'),
          ContainerCheckOut(title: 'Ar quente / Ventilação'),
          ContainerCheckOut(title: 'Rádio / CD / DVD / MP3'),
          ContainerCheckOut(title: 'Buzinas'),
          ContainerCheckOut(title: 'Teto / Painel / Quebra-sol'),
          ContainerCheckOut(title: 'Partida e func. do motor'),
          ContainerCheckOut(title: 'Vidros elétricos'),
          ContainerCheckOut(title: 'Alarme'),
          ContainerCheckOut(title: 'Condições instalação elétrica'),
          ContainerObservacaoAdicional(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => (RelateMotivo())),
              );
            },
          ),
        ],
      ),
    );
  }
}