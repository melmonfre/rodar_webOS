import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constantes/Urlconst.dart';

class SincronizarOS{
  sincronize() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var referencias = opcs.getStringList('referencias');
    List<String>? ids = opcs.getStringList('osIDaFinalizar');

    ids?.forEach((osid) {
      var body;
      body = opcs.getString("${osid}@OSaFinalizardeslocamento");
      enviardeslocamento(osid, body);
      referencias?.forEach((referencia) {
        body = opcs.getString("${osid}@OSaFinalizarenviarimagem@${referencia}");
        enviarimagem(body, osid, referencia);
      });
       body = opcs.getString("${osid}@OSaFinalizainiciarconfirmacao");
       iniciarConfirmacao(body, osid);
       body = opcs.getString("${osid}@OSaFinalizaenviarconfirmacao");
       enviarConfirmacao(body, osid);
    });
    List<String>? idsVF = opcs.getStringList("osIDaFinalizarvf");
    idsVF?.forEach((osid) {
      var body;

      body = opcs.getString("${osid}@OSaFinalizarvf");
      enviamotivosvf(body, osid);
      body = opcs.getString("${osid}@OSaFinalizarvfoto");
      enviardiversasfotosvf(body, osid);
      body = opcs.getString("${osid}@OSaFinalizarvfdeslocamento");
      enviardeslocamento(osid, body);

    });

  }
  enviardeslocamento(osid, body) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body;

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardeslocamento/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception('enviardeslocamento http.post error: statusCode= $status');
    }
    print(res.body);
  }
  enviarimagem(body, osid, referencia) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = body;

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarfotos/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      throw Exception('http.post error: statusCode= $status');
    } else{
      opcs.remove("${osid}@OSaFinalizarenviarimagem@${referencia}");
      print(res.body);
    }
  }
  iniciarConfirmacao(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = body;
    
    final url = Uri.parse('${Urlconst().url}ordem_servico/inicia_confirmacao');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      throw Exception('http.post error: statusCode= $status');
    } else{
      opcs.remove("${osid}@OSaFinalizainiciarconfirmacao");
      print(res.body);
    }


  }
  enviarConfirmacao(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var data = body;
        
    final url = Uri.parse('${Urlconst().url}ordem_servico/envia_confirmacao');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      opcs.setString("osIDaFinalizar", osid);
      opcs.setString("${osid}@OSaFinalizaenviarconfirmacao", data);
      throw Exception('http.post error: statusCode= $status');
    } else{
      opcs.remove("${osid}@OSaFinalizaenviarconfirmacao");
      print(res.body);
    }
  }

  
  enviardiversasfotosvf(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body ;

    final url = Uri.parse('${Urlconst().url}ordem_servico/enviardiversasfotosvf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    }
    opcs.remove("${osid}@OSaFinalizarvfoto");
    print(res.body);
  }

  enviamotivosvf(body, osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var data = body;
    final url = Uri.parse('${Urlconst().url}ordem_servico/enviarmotivovf/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      throw Exception('http.post error: statusCode= $status');
    } else {
      opcs.remove("${osid}@OSaFinalizarvf");
      print(res.body);

    }

  }
}

