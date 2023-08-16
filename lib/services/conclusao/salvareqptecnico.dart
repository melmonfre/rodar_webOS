import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class salvareqtec {
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var json = await opcs.getString("SelectedOS");
    var dados = jsonDecode(json!);
    var osid = dados['id'];
    var equipamentos = jsonEncode(dados['equipamentos']);

    /*"EquipamentoInstaladoID": eqnovosid,
    "EquipamentoInstaladoCodigo": selecionadonovo,
    "EquipamentosRemovidoID": "",
    "EquipamentoRemovidoCodigo": "",
    "localInstalacao": localInstalacao,*/

    var jsoneqs = opcs.getStringList("EQProcess");

    jsoneqs?.forEach((element) {
      var eqs = jsonDecode(element!);
      if (eqs["control"] == "RETIRADA") {
        String equipaments = '''{
          "id":${eqs['EquipamentosRemovidoID']},
          "tipo":"RETIRADA",
          "tipoTec":"RETIRADA",
          "equipamento":"",
          "equipamentoTec":"",
          "equipamentoRetirado":"${eqs['EquipamentoRemovidoCodigo']}",
          "equipamentoRetiradoTec":"${eqs['EquipamentoRemovidoCodigo']}",
          "localInstalacao":"",
          "localIntalacaoTec":""
        }''';
        dados["equipamentos"] = jsonDecode(equipaments);
        json = jsonEncode(dados);
      } else if (eqs["control"] == "INSTALACAO") {
        String equipaments = '''
        {
          "id":${eqs['EquipamentoInstaladoID']},
          "tipo":"INSTALACAO",
          "tipoTec":"INSTALACAO",
          "equipamento":"${eqs['EquipamentoInstaladoCodigo']}",
          "equipamentoTec":"${eqs['EquipamentoInstaladoCodigo']}",
          "equipamentoRetirado":"",
          "equipamentoRetiradoTec":"",
          "localInstalacao": "${eqs['localInstalacao']}",
          "localIntalacaoTec": "${eqs['localInstalacao']}"
        }
        ''';
        dados["equipamentos"] = jsonDecode(equipaments);
        json = jsonEncode(dados);
      } else if (eqs["control"] == "TROCA") {
        var equipaments = '''
          {
            "id":${eqs['EquipamentoInstaladoID']},
            "tipo":"TROCA",
            "tipoTec":"TROCA",
            "equipamento":"${eqs['EquipamentoInstaladoCodigo']}",
            "equipamentoTec":"${eqs['EquipamentoInstaladoCodigo']}",
            "equipamentoRetirado":"${eqs['EquipamentoRemovidoCodigo']}",
            "equipamentoRetiradoTec":"${eqs['EquipamentoRemovidoCodigo']}",
            "localInstalacao":"${eqs['localInstalacao']}",
            "localIntalacaoTec":"${eqs['localInstalacao']}"
          }
        ''';
        dados["equipamentos"] = jsonDecode(equipaments);
        json = jsonEncode(dados);
      } else {
        var equipaments = '''
        {
          "id":${eqs['EquipamentosRemovidoID']},
          "tipo":"MANUTENCAO",
          "tipoTec":"MANUTENCAO",
          "equipamento":"${eqs['EquipamentoInstaladoCodigo']}",
          "equipamentoTec":"${eqs['EquipamentoInstaladoCodigo']}",
          "equipamentoRetirado":"",
          "equipamentoRetiradoTec":"",
          "localInstalacao":"${eqs['localInstalacao']}";,
          "localIntalacaoTec":"${eqs['localInstalacao']}";
        }
        ''';
        dados["equipamentos"] = jsonDecode(equipaments);
        json = jsonEncode(dados);
      }
    });

    var body = '$json';
    final data = body;

    final url =
        Uri.parse('${Urlconst().url}ordem_servico/salvar_equipamentos_tecnico');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.reasonPhrase);
    print(res.request);
    print(res.headers);
    print(res.body);
  }
}
