//exibe uma lista de equipamentos disponiveis vinculados ao tecnico
import 'package:http/http.dart' as http;
class getequiptec{
  obter(var token) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('https://siger.winksys.com.br:8443/v2/equipamento/list_equipamentos_tecnico');
    var res = await http.get(url, headers: headers);
    if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
    print(res.body);
  }
}
