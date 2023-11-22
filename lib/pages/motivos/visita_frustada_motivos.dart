import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/tela_inicial/tela_inicial.dart';
import 'package:rodarwebos/services/Visita%20Frustrada/ConcluirVisitaFrustrada.dart';
import 'package:rodarwebos/widgets/botoes/botao_enviar.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class VisitaFrustadaMotivo extends StatefulWidget {
  @override
  _VisitaFrustadaMotivoState createState() => _VisitaFrustadaMotivoState();
}

class _VisitaFrustadaMotivoState extends State<VisitaFrustadaMotivo> {
  var motivo;
  var json;
  var osid;
  var element;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    setState(() {
      osid = element['id'];
    });
  }
  void initState() {
    getdata();
    super.initState();
  }

  addToListaOcultar(String osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    List<String> osAOcultar = opcs.getStringList('osAOcultar') ?? [];

    if (osAOcultar.length > 50) {
      osAOcultar = osAOcultar.sublist(20);
    }

    osAOcultar.add(osid);
    
    await opcs.setStringList("osAOcultar", osAOcultar);
  }

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
        title: Text('Visita frustada'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$osid",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Relate os motivos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InputMotivos(
                        labelText:
                            'Relate os motivos da visita frustrada',
                        onChanged:  (value) {
                          motivo = value;
                          gravamotivo(motivo);
                        }
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: BotaoEnviar(
                        onPressed: () async {
                          concluivf().concluir();
                          Fluttertoast.showToast(
                            msg: 'Enviado com sucesso',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );

                          await addToListaOcultar(osid.toString());

                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TelaInicial()),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> gravamotivo(motivo) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
   opcs.setString("motivovf", motivo);
  }
}
