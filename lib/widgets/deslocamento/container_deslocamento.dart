import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rodarwebos/models/selected_os_model.dart';
import 'package:rodarwebos/tools/tools.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/inputs/input_motivos.dart';
import 'package:rodarwebos/widgets/inputs/input_number.dart';
import 'package:rodarwebos/widgets/inputs/input_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContainerDeslocamento extends ConsumerStatefulWidget {
  final String titulo;
  final VoidCallback onPressed;

  const ContainerDeslocamento({
    required this.titulo,
    required this.onPressed,
  });

  @override
  _ContainerDeslocamentoState createState() => _ContainerDeslocamentoState();
}

class _ContainerDeslocamentoState extends ConsumerState<ContainerDeslocamento> {
  String motivoDivergencia = '';
  double? disCalc;
  double? disper;
  double? valor;
  double? pedagio;

  var latitude;
  var longitude;
  var osid;

  void getLocation() async {
    Position position = (await Geolocator.getLastKnownPosition()) ??
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

    debugPrint('latitude:  ' + position.latitude.toString());
    debugPrint('longitude: ' + position.longitude.toString());

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  salvar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    Map<String, dynamic> values = {
      "latitude": latitude,
      "longitude": longitude,
      "distanciaCalculada": disCalc,
      "distanciaPercorrida": disper,
      "valor": valor,
      "pedagio": pedagio,
      "motivoDiv": motivoDivergencia,
    };

    await opcs.setString(buildStorageKeyString(ref.read(selectedOsProvider).osId, Etapa.DESLOCAMENTO.key), jsonEncode(values));
    await opcs.setString("dadosdeslocamento", jsonEncode(values));
    ref.read(selectedOsProvider).updateEtapasState();
  }

  Future<void> getdata() async {
    // SharedPreferences opcs = await SharedPreferences.getInstance();
    // json = opcs.getString("SelectedOS");

    final selectedOs = ref.read(selectedOsProvider);
    final element = selectedOs.getOs();
    // empresaid = opcs.getInt('sessionid');
    // element = jsonDecode(json);
    // token = opcs.getString("${empresaid}@token")!;

    setState(() {
      osid = element['id'];
      disCalc = element['distanciaDeslocamentoOriginal'];
      disper = element['distanciaDeslocamentoOriginal'];
      valor = element['valorDeslocamentoOriginal'];
      pedagio = element['valorPedagioOriginal'];
    });
  }

  irProximo() {
    Navigator.of(context).pop();
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
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "$osid",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
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
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        widget.titulo,
                        style: const TextStyle(
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
                    if (disper != disCalc) const SizedBox(height: 3.0),
                    if (disper != disCalc)
                      InputMotivos(
                        labelText: 'Qual o motivo da diferença de deslocamento?',
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
                    const SizedBox(height: 5.0),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16.0),
                      child: BotaoProximo(
                        onPressed: () {
                          if (disper != null &&
                              disper! >=
                                  0 && // Verificar se a distância percorrida não é nula e maior ou igual a zero
                              pedagio != null &&
                              pedagio! >= 0) {
                            // Verificar se a distância percorrida não é zero) {
                            salvar();
                            widget.onPressed();
                            irProximo();
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Erro'),
                                  content:
                                      const Text('Por favor, preencha todos os campos obrigatórios.'),
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
