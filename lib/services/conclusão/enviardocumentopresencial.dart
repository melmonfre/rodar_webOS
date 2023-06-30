import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class enviardocconfirmacaopresencial{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

      final data = '{\n    "id": 5175,\n    "nome": "Guilherme",\n    "tipoEnvio": "presencial",\n    "idOs": 108527,\n    "documento": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD...",\n    "referencia": "Documento Frente", \n    "etapa": "REENVIO_RESPONSAVEL"\n}';

      final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/envia_documento');

      final res = await http.post(url, headers: headers, body: data);
      final status = res.statusCode;
      if (status != 200) throw Exception('http.post error: statusCode= $status');

      print(res.body);

  }
  
}