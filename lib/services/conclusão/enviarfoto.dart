import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class enviarfoto{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data = '{\n    "base64": "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAZABkAAD/2wBDAAkGBwgHBgkIBw...",\n    "etapa": "ACESSORIOS", \n    "indice": 1, \n    "referencia": "Tirar foto hodometro" \n}';

    final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/enviarfotos/108527');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}