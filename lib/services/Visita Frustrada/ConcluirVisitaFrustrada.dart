import 'dart:convert';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class concluivf{

  Future<String> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    return "${position.latitude},${position.longitude}";
  }

  concluir() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var dadosdeslocamento = opcs.getString("dadosdeslocamento");
    var deslocamento = jsonDecode(dadosdeslocamento!);
    var os = opcs.getString("SelectedOS");
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var motivo = opcs.getString("motivovf");
    var element = jsonDecode(os!);
    var osid = element['id'];
    var DistanciaTec = deslocamento['distanciaPercorrida'];
    var distanciacalc = deslocamento['distanciaCalculada'];
    var valorDeslocamentoTec = deslocamento['valor'];
    var pedagioTec = deslocamento['pedagio'];
    var motivoDiv = element['motivoDiv'];
    String? base64images = opcs.getString("base64vf");

    var localGps = await getLocation();

    await enviardiversasfotosvf(osid, token, base64images);

    await enviardeslocamentovf(osid, token, DistanciaTec, valorDeslocamentoTec, pedagioTec);

    await enviamotivosvf(osid, token, motivo, localGps);
  }

  enviamotivosvf(osid, token, motivo, localGps) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = '{"motivo":"$motivo","localGps":"$localGps"}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarmotivovf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      List<String>? ids = opcs.getStringList("osIDaFinalizarvf");
      if(ids == null){
        ids = [];
        ids.add("$osid");
      }
      opcs.setStringList("osIDaFinalizarvf", ids);
      opcs.setString("${osid}@OSaFinalizarvf", data);

      throw Exception('enviamotivosvf http.post error: statusCode= $status');
    }
    print("VISITA FRUSTRADA");
    print(res.body);
  }


  enviardiversasfotosvf(osid, token, String?image) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String> fotos = [];
    fotos.add(image!);
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{"base64":${jsonEncode(fotos)},"idsRemove":[]}';
    print(data);
    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardiversasfotos/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      opcs.setString("${osid}@OSaFinalizarvfoto", data);
      print("RESPOSTA: ${res}");
      print("RESPOSTA ${res.body}");
      throw Exception('enviardiversasfotosvf http.post error: statusCode= $status');
    }
    print(res.body);
  }

  enviardeslocamentovf(osid, token, distanciaTec, valorDeslocamentoTec, pedagioTec) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{"distanciaTec":$distanciaTec,"valorDeslocamentoTec":$valorDeslocamentoTec,"pedagioTec":$pedagioTec}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardeslocamento/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      opcs.setString("${osid}@OSaFinalizarvfdeslocamento", data);
      throw Exception('enviardeslocamentovf http.post error: statusCode= $status');
    }
    print(res.body);
  }
}