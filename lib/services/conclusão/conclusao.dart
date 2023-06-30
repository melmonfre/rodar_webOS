import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class conclusao{
  enviar()async{
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data = '{\n    "dataConclusaoOs": "2023-06-29T16:36:27.119Z",\n    "observacaoOs": "Concluido com sucesso",\n    "hodometro": 0,\n    "etapa": "DESLOCAMENTO"\n}';

    final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/dadosos/108527');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}