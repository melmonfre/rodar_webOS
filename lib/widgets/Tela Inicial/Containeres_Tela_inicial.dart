import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rodarwebos/main.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_amanha.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_atrasadas.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_futuras.dart';
import 'package:rodarwebos/pages/ordem_de_servico/listagem_ordem_servico/lista_os_hoje.dart';
import 'package:rodarwebos/pages/os_em_execucao.dart';
import 'package:rodarwebos/services/OS/os_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/getToken.dart';

class OsCard extends StatelessWidget {
  Color color;
  Color? textColor;

  String text;
  String amount;

  OsCard(
      {super.key, required this.color, required this.text, required this.amount, this.textColor});

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
              ),
              Text(
                amount,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: textColor),
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
  Timer? counter;

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
    counter = Timer.periodic(const Duration(milliseconds: 1100), (_) {
      try {
        getdata();
        // debugPrint('getting count futuras...');
      } catch (e) {}
    });
  }

  void initState() {
    getdata();
    _decrementCounter();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("dispose timer");
    counter?.cancel();
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
  Timer? counter;
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
    counter = Timer.periodic(const Duration(seconds: 900), (_) {
      try {
        // debugPrint('getting count amanha...');

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
  void dispose() {
    super.dispose();
    debugPrint("dispose timer");
    counter?.cancel();
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
  Timer? counter;

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
    counter = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      try {
        // debugPrint('getting count hoje...');
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
  void dispose() {
    super.dispose();
    debugPrint("dispose timer");
    counter?.cancel();
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
  Timer? counter;

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
    counter = Timer.periodic(const Duration(seconds: 1), (_) {
      try {
        // debugPrint('getting count atrasadas...');
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
  void dispose() {
    super.dispose();
    debugPrint("dispose timer");
    counter?.cancel();
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

class ContainerContent extends ConsumerStatefulWidget {
  const ContainerContent({Key? key}) : super(key: key);

  @override
  ConsumerState<ContainerContent> createState() => _ContainerContentState();
}

class _ContainerContentState extends ConsumerState<ContainerContent> {
  Timer? sincronizacaoTimer;
  Timer? carregandoTimer;

  bool carregando = false;
  var timer = 5;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  var selectedOs;

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

  void getSelectedOs() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    try {
      final json = opcs.getString("SelectedOS");
      final os = jsonDecode(json!);

      setState(() {
        selectedOs = os["id"];
      });
    } catch (e) {
      // nenhuma os selecionada
    }
  }

  @override
  void initState() {
    getdata();
    createTimers();
    getSelectedOs();
    super.initState();

    Permission.storage.request().then((value) {
      debugPrint('storage permission request result: ' + value.toString());
    });
  }

  @override
  void dispose() {
    sincronizacaoTimer?.cancel();
    carregandoTimer?.cancel();
    debugPrint("dispose timer principal");
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
                if (ref.watch(selectedOsProvider).hasSelectedOs) GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OsEmExecucao()),
                    );
                  },
                  child: OsCard(
                    textColor: const Color.fromARGB(255, 255, 255, 255),
                    color: Theme.of(context).primaryColor,
                    text: 'Continuar OS ${ref.watch(selectedOsProvider).osId}',
                    amount: '',
                  ),
                ),
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