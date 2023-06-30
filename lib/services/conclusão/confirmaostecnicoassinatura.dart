import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class confirmassinatura{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data = '{\n    "base64": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAS...",\n    "referencia": "Assinatura Tecnico",\n    "etapa": "CONCLUSAO"\n}';

    final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/confirmaostecnico/108527');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}