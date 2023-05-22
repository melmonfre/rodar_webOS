import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';

class GetOSAmanha{
  //obtem as os de amanhã
    obter(var token) async {
     var retorno;
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = '{\n  "value": {\n    "tipo": 1\n  },\n  "first": 0,\n  "rows": 100,\n  "sorts": [\n    {\n      "campo": "id",\n      "asc": true\n    }\n  ]\n}';

    var url = Uri.parse('${Urlconst().url}ordem_servico/tecnico');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    retorno = res.body;
    print(retorno);
    return retorno;
  }
}
