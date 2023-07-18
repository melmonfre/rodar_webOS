import 'dart:convert';

import 'package:rodarwebos/services/Sincronizar/sincronizarOffline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constantes/Urlconst.dart';


class concluiOS {

  concluir(osid) async {
    syncoff().criarjson();
    syncoff().enviar(osid);
  }
}