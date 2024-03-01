import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rodarwebos/services/debug_service.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/Sincronizar/Sincronizar.dart';

class TelaSincronizar extends StatefulWidget {
  const TelaSincronizar({Key? key}) : super(key: key);

  @override
  State<TelaSincronizar> createState() => _TelaSincronizarState();
}

class _TelaSincronizarState extends State<TelaSincronizar> {
  int countafinalizar = 0;
  int countvf = 0;

  getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var vfafinalizar = opcs.getStringList('osIDaFinalizarvf');
    var afinalizar = opcs.getStringList('osIDaFinalizar');

    setState(() {
      debugPrint('atualizando contagem...');
      countvf = vfafinalizar?.length ?? 0;
      countafinalizar = afinalizar?.length ?? 0;
    });
  }

  Timer? counter;

  void _decrementCounter() {
    counter = Timer.periodic(const Duration(milliseconds: 1100), (_) {
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
  void dispose() {
    super.dispose();
    counter?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var variaveis = VariaveisResumo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sincronizar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text('Opções'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          DebugService.saveOrdensASincronizarToDownloads(
                              context);
                        },
                        child: const Text(
                            'Exportar ordens de serviço a sicronizar'),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          DebugService.limparListaDeOrdensOcultas();

                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Sucesso'),
                                content: const Text('Lista removida.'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text(
                            'Limpar lista de ordens de serviço ocultas'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centraliza os elementos verticalmente
          children: [
            SizedBox(height: 16.0),
            // Container com texto
            Container(
              alignment: Alignment.center,
              child: Text(
                'Existem $countafinalizar Ordens de serviço a ser sincronizadas',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 24.0),
            // Container com texto
            Container(
              alignment: Alignment.center,
              child: Text(
                'Existem $countvf Visitas frustradas a ser sincronizadas',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30.0),
            // Botão
            _BotaoSincronizar(),
          ],
        ),
      ),
    );
  }
}

class _BotaoSincronizar extends StatefulWidget {
  @override
  State<_BotaoSincronizar> createState() => _BotaoSincronizarState();
}

class _BotaoSincronizarState extends State<_BotaoSincronizar> {
  bool isSyncing = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20.0,
        child: ElevatedButton(
          onPressed: isSyncing
              ? null
              : () async {
                  setState(() {
                    isSyncing = true;
                  });

                  try {
                    await SincronizarOS().sincronize();
                  } catch (e) {}

                  setState(() {
                    isSyncing = false;
                  });
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            foregroundColor: Color(0xFF00204E), // Cor do botão
            shadowColor: Colors.black.withOpacity(0.2), // Cor da sombra
            elevation: 4.0, // Elevação da sombra
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Border radius do botão
            ),
          ),
          child: Text(
            isSyncing ? 'Sincronizando...' : 'Sincronizar',
            style: TextStyle(
              color: Colors.white, // Cor do texto
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }
}
