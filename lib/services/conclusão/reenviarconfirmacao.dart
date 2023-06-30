import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class reenvianot{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

      final data = '{\n    "id": 0,\n    "nome": "Outro",\n    "tipoEnvio": "email",\n    "email": "amelissariver@gmail.com",\n    "telefone": "55(55) 55555-5555",\n    "idOs": 108527,\n    "etapa": "ENVIO_RESPONSAVEL"\n}';

      final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/reenvia_notificacao');

      final res = await http.post(url, headers: headers, body: data);
      final status = res.statusCode;
      if (status != 200) throw Exception('http.post error: statusCode= $status');

      print(res.body);

  }
}