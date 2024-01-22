import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class enviacheckout {
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var latitude;
    var longitude;
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    latitude = position.latitude;
    longitude = position.longitude;
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var osid = element['id'];
    var jsoncheckin = opcs.getString("checkinitens");
    var jsoncheckout = opcs.getString("checkoutitens");
    var datacheckout = jsonDecode(jsoncheckout!);
    var datacheckin = jsonDecode(jsoncheckin!);
    var idcheckin = await datacheckin['idscheckin'];
    var nomescheckin = datacheckin['nomescheckin'];
    var itenscheckin = datacheckin['itenscheckin'];
    var itenscheckout = datacheckout['itenscheckin'];
    var obscheckin = datacheckin['obscheckin'];
    String data = '';
    String? obsadc = opcs.getString("obscheckin");
    for (int i = 0; i < idcheckin.length; i++) {
      var obs = "";
      if (obscheckin[i] != "") {
        obs = ',"observacaoAntes": "${obscheckin[i]}"';
      } else {
        obs = "";
      }
      String virgula = "";
      if (i < idcheckin.length - 1) {
        virgula = ",";
      } else {
        virgula = "";
      }

      data =
          '$data{"id": ${idcheckin[i]},"descricao": "${nomescheckin[i]}","situacaoAntes": "${itenscheckin[i]}", "situacaoDepois": "${itenscheckout[i]}" $obs}$virgula';
    }
    //print(data);
    if (obsadc == null) {
      obsadc = "";
    }
    String body =
        '{"itens": [$data],"localGps": "$latitude,$longitude","etapa": "DESLOCAMENTO"}';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    data = body;
    final url = Uri.parse('${Urlconst().url}ordem_servico/checkout');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.reasonPhrase);
    print(res.request);
    print(res.headers);
    print(res.body);
  }
}
