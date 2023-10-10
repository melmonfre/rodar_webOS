import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Constantes/Urlconst.dart';

class validatoken {
  validar(token) async {
    var url = Uri.parse('${Urlconst().url}token/codigo/${token}');
    var res = await http.get(url);
    if (res.statusCode == 401) {
      return true; // true quando ha erro
    } else {
      return false; // false quando não ha erro
    }
  }

  validabearer(empresaid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var token = opcs.getString("${empresaid}@token")!;
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var url = Uri.parse('${Urlconst().url}usuario/info');
    var res = await http.get(url, headers: headers);
    print("validabearer ${res.statusCode}");
    if (res.statusCode == 500)
      return true; // true quando ha erro
    else {
      return false; // false quando não ha erro
    }
  }
}
