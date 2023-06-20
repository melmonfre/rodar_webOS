import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constantes/Urlconst.dart';


class concluiOS{

  concluir() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var dadosdeslocamento = opcs.getString("dadosdeslocamento");
    var deslocamento = jsonDecode(dadosdeslocamento!);
    var os = opcs.getString("SelectedOS");
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var motivo = opcs.getString("motivovf");
    var element = jsonDecode(os!);
    var osid = element['id'];
    var DistanciaTec = deslocamento['distanciaPercorrida'];
    var distanciacalc = deslocamento['distanciaCalculada'];
    var valorDeslocamentoTec = deslocamento['valor'];
    var pedagioTec = deslocamento['pedagio'];
    var motivoDiv = element['motivoDiv'];
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

     var datacon = opcs.getString("DadosContato");
     var contato = jsonDecode(datacon!);
     var tipoenvio;
     if (contato['responsavelAusente']){
       tipoenvio = "email";
     } else{
       tipoenvio = "presencial";
     }
     var base64image = opcs.getString("assinaturaresponsavel");
    iniciarConfirmacao(contato['id'], contato['nome'], contato['email'], contato['telefone'], osid, tipoenvio);
    enviarConfirmacao(contato['id'], contato['nome'], contato['email'], contato['telefone'], osid, tipoenvio, base64image);
    enviardeslocamento(osid, token, distanciacalc, DistanciaTec, pedagioTec);

    var localGps = "${opcs.getStringList("latitude")},${opcs.getStringList("longitude")}";

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

    var data = '{"base64": "$imagem",\n"referencia": "$referencia",\n"etapa": "ACESSORIOS"\n, "indice": $indice}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarfotos/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){

      opcs.setString("osIDaFinalizar", "$osid");
      opcs.setString("${osid}@OSaFinalizarenviarimagem@${referencia}", data);
      opcs.setString("${osid}@OSaFinalizarenviarreferencias", referencia);

      throw Exception('http.post error: statusCode= $status');
    } else{
      print(res.body);
    }
  }
  iniciarConfirmacao(id, nome, email, telefone, osid, tipoenvio) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = '{"id":$id,"nome":"$nome","tipoEnvio":"$tipoenvio","email":"$email","telefone":"$telefone","idOs":$osid,"etapa":"ASSINATURA_TECNICO"}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/inicia_confirmacao');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      List<String>? ids = opcs.getStringList("osIDaFinalizar");
      if(ids == null){
        ids = [];
        ids.add("$osid");
      }

      opcs.setStringList("osIDaFinalizar", ids);
      opcs.setString("${osid}@OSaFinalizainiciarconfirmacao", data);
      throw Exception('http.post error: statusCode= $status');
  } else{
      print(res.body);
    }


  }
  enviarConfirmacao(id, nome, email, telefone, osid, tipoenvio, base64image) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = ' {"id":$id,"nome":"$nome","tipoEnvio":"$tipoenvio","idOs":$osid,"assinatura":"$base64image","observacaoCliente":"Avaliação do serviço: 5\\n","etapa":"ASSINATURA_TECNICO"}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/envia_confirmacao');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      List<String> ids = [];
      if(ids == null){
        ids = [];
        ids.add("$osid");
      }

      opcs.setStringList("osIDaFinalizar", ids);
      opcs.setString("${osid}@OSaFinalizaenviarconfirmacao", data);
      throw Exception('http.post error: statusCode= $status');
    } else{
      print(res.body);
    }
  }
  enviardeslocamento(osid, token, distanciaTec, distanciacalc, pedagioTec) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = '{"distanciaTec":$distanciacalc,"distanciaTec":$distanciaTec,"pedagioTec":$pedagioTec}';

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardeslocamento/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      opcs.setString("${osid}@OSaFinalizardeslocamento", data);
      throw Exception('enviardeslocamento http.post error: statusCode= $status');
    }
    print(res.body);
  }
}

