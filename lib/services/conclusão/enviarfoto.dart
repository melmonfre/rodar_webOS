import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';
class enviarfoto{
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var os = opcs.getString("SelectedOS");
    var element = jsonDecode(os!);
    var osid = element['id'];

    String ref = "";
    List<String>? FotoHodometro = opcs.getStringList('FotoHodometro');
    ref = "Tirar foto hodometro";
    enviarimagem(osid, FotoHodometro?[0], ref, 1);

    List<String>? FotoInstalacao = opcs.getStringList('FotoInstalacao');
    ref = "Tirar foto da instalação";
    enviarimagem(osid, FotoInstalacao?[0], ref, 2);

    List<String>? FotoEquipamento = opcs.getStringList('FotoEquipamento');
    ref = "Tirar do equipamento";
    enviarimagem(osid, FotoEquipamento?[0], ref, 3);

  }

  enviarimagem(osid, imagem, referencia, int indice) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = '{"base64": "$imagem",\n"etapa": "ACESSORIOS"\n, "indice": $indice,\n"referencia": "$referencia"}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarfotos/108527');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.body);
  }
}