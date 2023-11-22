import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_amanha.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_atrasadas.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_futuras.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_hoje.dart';
import 'package:rodarwebos/services/OS/os_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/getToken.dart';

class OsCard extends StatelessWidget {
  Color color;
  String text;
  String amount;

  OsCard({super.key, required this.color, required this.text, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9.0),
        ),
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                amount,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Futuras extends StatefulWidget {
  @override
  State<Futuras> createState() => _FuturasState();
}

int numdodia = 0;
int numfuturas = 0;
int numamanha = 0;
int numatrasadas = 0;

class _FuturasState extends State<Futuras> {
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final empresaid = opcs.getInt("sessionid");

    final osService = OsService(empresaId: empresaid);

    final futuras = await osService.getOsFuturas();

    setState(() {
      numfuturas = futuras.length;
    });
  }

  void _decrementCounter() {
    Timer.periodic(const Duration(milliseconds: 1100), (_) {
      try {
        getdata();
      } catch (e) {}
    });
  }

  void initState() {
    getdata();
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
      child: OsCard(color: const Color(0xFFA0E8A1), text: 'Futuras', amount: numfuturas.toString()),
    );
  }
}

class Amanha extends StatefulWidget {
  @override
  State<Amanha> createState() => _AmanhaState();
}

class _AmanhaState extends State<Amanha> {
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final empresaid = opcs.getInt("sessionid");

    final osService = OsService(empresaId: empresaid);

    final amanha = await osService.getOsAmanha();

    setState(() {
      numamanha = amanha.length;
    });
  }

  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 900), (_) {
      try {
        getdata();
      } catch (e) {}
    });
  }

  void initState() {
    getdata();
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
        child: OsCard(
          text: 'Amanhã',
          amount: numamanha.toString() ?? "",
          color: const Color(0xFFFFE192),
        ));
  }
}

class Hoje extends StatefulWidget {
  @override
  State<Hoje> createState() => _HojeState();
}

class _HojeState extends State<Hoje> {
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final empresaid = opcs.getInt("sessionid");

    final osService = OsService(empresaId: empresaid);

    final hoje = await osService.getOsHoje();

    setState(() {
      numdodia = hoje.length;
    });
  }

  void _decrementCounter() {
    Timer.periodic(const Duration(milliseconds: 1200), (_) {
      try {
        getdata();
      } catch (e) {}
    });
  }

  void initState() {
    getdata();
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
      child: OsCard(color: const Color(0xFF9CDEFF), text: 'Do dia', amount: numdodia.toString()),
    );
  }
}

class Atrasadas extends StatefulWidget {
  @override
  State<Atrasadas> createState() => _AtrasadasState();
}

class _AtrasadasState extends State<Atrasadas> {
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    final empresaid = opcs.getInt("sessionid");

    final osService = OsService(empresaId: empresaid);

    final atrasadas = await osService.getOsAtrasadas();

    setState(() {
      numatrasadas = atrasadas.length;
    });
  }

  void _decrementCounter() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      try {
        getdata();
      } catch (e) {}
    });
  }

  void initState() {
    getdata();
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
      child: OsCard(
          color: const Color(0xFFE8716F), text: 'Atrasadas', amount: numatrasadas.toString()),
    );
  }
}

class ContainerContent extends StatefulWidget {
  const ContainerContent({Key? key}) : super(key: key);

  @override
  State<ContainerContent> createState() => _ContainerContentState();
}

class _ContainerContentState extends State<ContainerContent> {
  Timer? sincronizacaoTimer;
  Timer? carregandoTimer;

  bool carregando = false;
  var timer = 5;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> getdata() async {
    debugPrint("getdata conteineres");
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt("sessionid");
    getToken().sincronizar(empresaid);
  }

  void createTimers() {
    sincronizacaoTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      setState(() {
        debugPrint('sincronizando containeres_tela_inicial');
        getdata();
      });
    });

    carregandoTimer = Timer.periodic(const Duration(milliseconds: 1000), (_) async {
      final opcs = await SharedPreferences.getInstance();

      bool carregandoStorage = opcs.getBool("carregando") ?? false;

      setState(() {
        carregando = carregandoStorage;
      });
    });
  }

  @override
  void initState() {
    getdata();
    createTimers();

    super.initState();
  }

  @override
  void dispose() {
    sincronizacaoTimer?.cancel();
    carregandoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.white,
        backgroundColor: Color(0xFF26738e),
        strokeWidth: 4.0,
        onRefresh: () async {
          if (!carregando) getdata();
          // return Future<void>.delayed(const Duration(seconds: 5));
        },
        child: SingleChildScrollView(
          physics: carregando ? null : const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 3.0),
                Container(
                  constraints: const BoxConstraints(maxHeight: 140.0),
                  child: Hoje(),
                ),
                const SizedBox(height: 3.0),
                Container(
                  constraints: const BoxConstraints(maxHeight: 140.0),
                  child: Atrasadas(),
                ),
                const SizedBox(height: 3.0),
                Container(
                  constraints: const BoxConstraints(maxHeight: 140.0),
                  child: Amanha(),
                ),
                const SizedBox(height: 3.0),
                Container(
                  constraints: const BoxConstraints(maxHeight: 140.0),
                  child: Futuras(),
                ),
                const SizedBox(height: 3.0),
                if (carregando)
                  Center(
                    child: Container(
                      width: 200,
                      child: LoadingIndicator(indicatorType: Indicator.ballSpinFadeLoader),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
