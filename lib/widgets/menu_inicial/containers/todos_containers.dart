import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_amanha.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_atrasadas.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_futuras.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_hoje.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/containers_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/variaveis.dart';
import 'package:rodarwebos/pages/ordem_de_servico/ordem_servico.dart';

class Futuras extends StatefulWidget {
  @override
  State<Futuras> createState() => _FuturasState();
}

class _FuturasState extends State<Futuras> {
  @override
  Widget build(BuildContext context) {
    var variaveis = Variaveis();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaOSFuturas()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          color: Color(0xFFA0E8A1),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Futuras',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  variaveis.numero_futuras.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Amanha extends StatefulWidget {
  @override
  State<Amanha> createState() => _AmanhaState();
}

class _AmanhaState extends State<Amanha> {
  @override
  Widget build(BuildContext context) {
    var variaveis = Variaveis();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaOSAmanha()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          color: Color(0xFFFFE192),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amanhã',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  variaveis.numero_amanha.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Hoje extends StatefulWidget {
  @override
  State<Hoje> createState() => _HojeState();
}

class _HojeState extends State<Hoje> {
  @override
  Widget build(BuildContext context) {
    var variaveis = Variaveis();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaOSHoje()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          color: Color(0xFF9CDEFF),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Do dia',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  variaveis.numero_dia.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Atrasadas extends StatefulWidget {
  @override
  State<Atrasadas> createState() => _AtrasadasState();
}

class _AtrasadasState extends State<Atrasadas> {
  @override
  Widget build(BuildContext context) {
    var variaveis = Variaveis();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListaOSAtrasadas()),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 2.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
          ),
          color: Color(0xFFE8716F),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Atrasadas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  variaveis.numero_dia.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class ContainerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 3.0),
            Container(
              constraints: BoxConstraints(maxHeight: 140.0),
              child: Hoje(),
            ),
            SizedBox(height: 3.0),
            Container(
              constraints: BoxConstraints(maxHeight: 140.0),
              child: Atrasadas(),
            ),
            SizedBox(height: 3.0),
            Container(
              constraints: BoxConstraints(maxHeight: 140.0),
              child: Amanha(),
            ),
            SizedBox(height: 3.0),
            Container(
              constraints: BoxConstraints(maxHeight: 140.0),
              child: Futuras(),
            ),
            SizedBox(height: 3.0),
          ],
        ),
      ),
    );
  }
}