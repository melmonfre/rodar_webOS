import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';

class enviardocconfirmacaopresencial {
  enviar() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var osid = element['id'];
    var datacon = opcs.getString("DadosContato");
    var contato = jsonDecode(datacon!);
    var tipoenvio;
    var assinatura = opcs.getString("assinaturaresponsavel");
    if (contato['responsavelAusente']) {
      tipoenvio = "email";
    } else {
      tipoenvio = "presencial";
    }
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final data =
        '{\n    "id": ${contato['id']},\n    "nome": "${contato['nome']}",\n    "tipoEnvio": "$tipoenvio",\n    "idOs": $osid,\n    "documento": "$assinatura",\n    "referencia": "Documento Frente", \n    "etapa": "REENVIO_RESPONSAVEL"\n}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/envia_documento');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) throw Exception('http.post error: statusCode= $status');

    print(res.reasonPhrase);
    print(res.request);
    print(res.headers);
    print(res.body);
  }
}
