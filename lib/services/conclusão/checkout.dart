import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class enviacheckout{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data = '{\n    "itens": [\n        {\n            "id": 15604,\n            "descricao": "Luzes Painel Instrumento",\n            "situacaoAntes": 0,\n            "situacaoDepois": "1",\n            "observacaoDepois": "Tinha uma luz vermelha escrito perigo que não parava de piscar"\n        },\n        {\n            "id": 15605,\n            "descricao": "Ar Condicionado",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15606,\n            "descricao": "Ar Quente / Ventilação",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15607,\n            "descricao": "Rádio / CD / DVD / MP3",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15608,\n            "descricao": "Buzinas",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15609,\n            "descricao": "Teto / Painel / Quebra Sol",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15610,\n            "descricao": "Partida e Func. do Motor",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15611,\n            "descricao": "Vidros Elétricos",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15612,\n            "descricao": "Alarme",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        },\n        {\n            "id": 15613,\n            "descricao": "Condições instalação elétrica",\n            "situacaoAntes": 0,\n            "situacaoDepois": "0"\n        }\n    ],\n    "localGps": "-23.66854286110172,-46.73391151021034",\n    "etapa": "DESLOCAMENTO"\n}';

    final url = Uri.parse('https://siger.winksys.com.br:8443/v2/ordem_servico/checkout');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}