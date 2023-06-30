import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rodarwebos/services/OS/ServicoIniciado.dart';
import 'package:shared_preferences/shared_preferences.dart';


class enviacheckin{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

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
      data = '$data{"id": ${idcheckin[i]},"descricao": "${nomescheckin[i]}","situacaoAntes": "${itenscheckin[i]}", "observacaoAntes": "${obscheckin[i]}"},';
    }
    String body = '{"itens": [$data],"localGps": "{},{}","$obsadc": "","etapa": "SERVICO_INICIADO"}';
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

     data = body;
     print(data);

    final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/checkin');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      throw Exception('http.post error: statusCode= $status');

    }

    print(res.body);
  }
}