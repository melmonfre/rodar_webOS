import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_amanha.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_atrasadas.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_futuras.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_hoje.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/todos_containers.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 100, // Ajuste a altura conforme necessário
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaOSAtrasadas(),
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                leading: IconTheme(
                  data: IconThemeData(
                    color: Color(0xFF26738E), // Define a cor dos ícones
                  ),
                  child: Icon(Icons.schedule),
                ),
                title: Text('OS Atrasadas'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaOSAmanha(),
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                leading: IconTheme(
                  data: IconThemeData(
                    color: Color(0xFF26738E), // Define a cor dos ícones
                  ),
                  child: Icon(Icons.calendar_today),
                ),
                title: Text('OS Amanhã'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaOSHoje(),
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                leading: IconTheme(
                  data: IconThemeData(
                    color: Color(0xFF26738E), // Define a cor dos ícones
                  ),
                  child: Icon(Icons.today),
                ),
                title: Text('OS Hoje'),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ListaOSFuturas(),
                  ),
                );
            },
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                leading: IconTheme(
                  data: IconThemeData(
                    color: Color(0xFF26738E), // Define a cor dos ícones
                  ),
                  child: Icon(Icons.forward),
                ),
                title: Text('OS Futuras'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
