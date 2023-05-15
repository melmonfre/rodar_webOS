import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/ordem_servico.dart';
import 'package:rodarwebos/widgets/botoes/botoes_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/containers_os.dart';

class ListaOSFuturas extends StatefulWidget {
  @override
  _ListaOSFuturasState createState() => _ListaOSFuturasState();
}

class _ListaOSFuturasState extends State<ListaOSFuturas> {
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
        title: Text('Do dia - OS Futuras'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContainerOS(
              botao: BotaoFuturas(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdemServico(),
                  ),
                );
              }),
            ),
            SizedBox(height: 0.2),
            ContainerOS(
              botao: BotaoFuturas(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdemServico(),
                  ),
                );
              }),
            ),
            SizedBox(height: 0.2),
            ContainerOS(
              botao: BotaoFuturas(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdemServico(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
