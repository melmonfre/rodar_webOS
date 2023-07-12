import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/deslocamento/variaveis_container_deslocamento.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_number.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/check_out/tela_check_out.dart';

class ContainerDeslocamento extends StatefulWidget {
  final String titulo;
  final VoidCallback onPressed;

  const ContainerDeslocamento({
    required this.titulo,
    required this.onPressed,
  });

  @override
  _ContainerDeslocamentoState createState() => _ContainerDeslocamentoState();
}

class _ContainerDeslocamentoState extends State<ContainerDeslocamento> {
  var variaveis = VariaveisDeslocamento();
  String motivoDivergencia = '';
  double? disCalc;
  double? disper;
  double? valor;
  double? pedagio;
  var latitude;
  var longitude;

  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    print(position.latitude);
    print(position.longitude);
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  salvanocache(valores) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("dadosdeslocamento", valores);
  }
  Future<void> getdata() async {
    var json;
    var osid;
    var element;
    var empresaid;
    var token;
    List checklist = [];

    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    empresaid = opcs.getInt('sessionid');
    element = jsonDecode(json);
    token = opcs.getString("${empresaid}@token")!;
    osid = element['id'];

    setState(() {
      disCalc = element['distanciaDeslocamentoOriginal'];
      disper = element['distanciaDeslocamentoOriginal'];
      valor = element['valorDeslocamentoOriginal'];
      pedagio = element['valorPedagioOriginal'];
    });

  }

  @override
  void initState() {
    super.initState();
    getdata();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  variaveis.numero_os.toString(),
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
                        widget.titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    InputNumber(
                      labelText: 'Distância calculada (KM): $disCalc',
                      enabled: false,
                    ),
                    InputNumber(
                      labelText: 'Distância percorrida (KM): $disper',
                      onChanged: (value) {
                        setState(() {
                          disper = double.tryParse(value) ?? 0.0;

                        });
                      },
                    ),
                    if (disper != disCalc) SizedBox(height: 3.0),
                    if (disper != disCalc)
                      InputMotivos(
                        labelText:
                            'Qual o motivo da diferença de deslocamento?',
                        onChanged: (value) {
                          setState(() {
                            motivoDivergencia = value;
                          });
                        },
                      ),
                    InputText(
                      labelText: 'Latitude: $latitude',
                      enabled: false,
                    ),
                    InputText(
                      labelText: 'Longitude: $longitude',
                      enabled: false,
                    ),
                    InputNumber(
                      labelText: 'Valor (R\$) $valor',
                      showInfoIcon: true,
                      onChanged: (value) {
                        setState(() {
                          valor = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    InputNumber(
                      labelText: 'Pedágio (R\$) $pedagio',
                      onChanged: (value) {
                        setState(() {
                          pedagio = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: BotaoProximo(
                        onPressed: () {
                          if (disCalc == null ||
                              valor == null ||
                              pedagio == null) {
                            Map<String, dynamic> values = {
                              "latitude": latitude,
                              "longitude": longitude,
                              "distanciaCalculada": disCalc,
                              "distanciaPercorrida" : disper,
                              "valor": valor,
                              "pedagio": pedagio,
                              "motivoDiv": motivoDivergencia,
                            };
                            salvanocache(jsonEncode(values));
                            widget.onPressed();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Erro'),
                                  content: Text(
                                      'Por favor, preencha todos os campos obrigatórios.'),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
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
}
