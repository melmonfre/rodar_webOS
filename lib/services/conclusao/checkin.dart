import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:rodarwebos/services/OS/ServicoIniciado.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';


class enviacheckin{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var latitude;
    var longitude;
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var  osid = element['id'];
    IniciaServico().iniciar(token, osid);
    var jsoncheckin = opcs.getString("checkinitens");
    var datacheckin = jsonDecode(jsoncheckin!);
    var idcheckin = await datacheckin['idscheckin'];
    var nomescheckin = datacheckin['nomescheckin'];
    var itenscheckin = datacheckin['itenscheckin'];
    var obscheckin = datacheckin['obscheckin'];
    print(idcheckin);
    String data = '';
    String? obsadc = opcs.getString("obscheckin");
    for(int i = 0; i < idcheckin.length; i++){
      var obs = "";
      if(obscheckin[i] != ""){
       obs  = ',"observacaoAntes": "${obscheckin[i]}"';
      } else {
        obs = "";
      }
      String virgula = "";
      if(i<idcheckin.length -1){
        virgula = ",";
      } else {
        virgula = "";
      }

      data = '$data{"id": ${idcheckin[i]},"descricao": "${nomescheckin[i]}","situacaoAntes": "${itenscheckin[i]}" $obs}$virgula';
    }
    //print(data);
    if(obsadc == null){
      obsadc = "";
    }
    String body = '{"itens": [$data],"localGps": "$latitude,$longitude","observacao": "$obsadc","etapa": "SERVICO_INICIADO"}';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
     data = body;
     print(data);
    final url = Uri.parse('${Urlconst().url}ordem_servico/checkin');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    print(res.reasonPhrase);
    print(res.request);
    print(res.headers);
    if (status != 200){
      throw Exception('http.post error: statusCode= $status');
    }

    print(res.body);
  }
}