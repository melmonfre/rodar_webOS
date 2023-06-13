import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_amanha.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_atrasadas.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_futuras.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_hoje.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/getToken.dart';

class Futuras extends StatefulWidget {
  @override
  State<Futuras> createState() => _FuturasState();
}
 int  numdodia = 0;
 int  numfuturas = 0;
 int  numamanha = 0;
 int  numatrasadas = 0;

class _FuturasState extends State<Futuras> {
  @override
  var empresaid;
  List varfuturas = [];
  var jsonfuturas;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    jsonfuturas =  opcs.getString("${empresaid}@GetOSFuturas");
    varfuturas = jsonDecode(jsonfuturas);
    int numero =0;
    varfuturas.forEach((element) {
      numero++;
      print(numero);
    });


    setState(() {
      numfuturas = numero;
    });
    //numfuturas = varfuturas.length;
  }
  var timer  = 1;
  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timer--;
        if (timer == 0) {
          getdata();
          timer = 5;
        }
      });
    });
  }
  void initState() {
    _decrementCounter();
    super.initState();
  }
  Widget build(BuildContext context) {
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

                  numfuturas.toString() ?? "",
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
  var empresaid;
  List varamanha = [];
  var jsonamanha;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    jsonamanha = opcs.getString("${empresaid}@GetOSAmanha");
    varamanha = jsonDecode(jsonamanha);

    int numero =0;
    varamanha.forEach((element) {
      numero++;
      print(numero);
    });
    setState(() {
      numamanha = numero;
    });
    //numamanha = varamanha.length;
  }
  var timer  = 1;
  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timer--;
        if (timer == 0) {
          getdata();
          timer = 5;
        }
      });
    });
  }
  void initState() {
    _decrementCounter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                 numamanha.toString() ?? "",
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
  var empresaid;
  List vardodia = [];

  var jsondodia;

  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    jsondodia = opcs.getString("${empresaid}@GetOSDia");
    vardodia = jsonDecode(jsondodia);

    int numero =0;
    vardodia.forEach((element) {
      numero++;
      print(numero);
    });
    setState(() {
      numdodia = numero;
    });

   // numdodia = vardodia.length;
  }
  var timer  = 1;
  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timer--;
        if (timer == 0) {
          getdata();
          timer = 5;
        }
      });
    });
  }
  void initState() {
    _decrementCounter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                  numdodia.toString() ?? "",
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
  var empresaid;
  List varatrasadas = [];
  var jsonatrasadas;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    jsonatrasadas = opcs.getString("${empresaid}@GetOSAtrasadas");
    varatrasadas = jsonDecode(jsonatrasadas);
    //numatrasadas = varatrasadas.length;

    int numero =0;
    varatrasadas.forEach((element) {
      numero++;
      print(numero);
    });
    setState(() {
      numatrasadas = numero;
    });
  }
  var timer  = 1;
  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        timer--;
        if (timer == 0) {
          getdata();
          timer = 5;
        }
      });
    });
  }
  void initState() {
    _decrementCounter();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                  numatrasadas.toString() ?? "",
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
class ContainerContent extends StatefulWidget {
  const ContainerContent({Key? key}) : super(key: key);

  @override
  State<ContainerContent> createState() => _ContainerContentState();
}

class _ContainerContentState extends State<ContainerContent> {

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    GlobalKey<RefreshIndicatorState>();
    Future<void> getdata() async {

      SharedPreferences opcs = await SharedPreferences.getInstance();
      var empresaid = opcs.getInt("sessionid");
      getToken().sincronizar(empresaid);

    }
    @override
    var timer  = 1;
    void _decrementCounter() {
      Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          timer--;
          if (timer == 0) {
            getdata();
            timer = 30;
          }
        });
      });
    }
    void initState() {
      _decrementCounter();
      super.initState();
    }
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Color(0xFF26738e),
        strokeWidth: 4.0,
        onRefresh: () async {
          return Future<void>.delayed(const Duration(seconds: 5));
        },
      child: SingleChildScrollView(
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
      ),
      ),
    );
  }
}



