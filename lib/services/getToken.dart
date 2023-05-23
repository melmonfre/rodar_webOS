import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Tokenconst.dart';
import 'package:rodarwebos/Constantes/Urlconst.dart';

class getToken{
 obter(var token) async {
  String token = "";
  var retorno;
  var url = Uri.parse('${Urlconst().url}token/codigo/${token}');
  var res = await http.get(url);
  if (res.statusCode != 200) throw Exception('http.get error: statusCode= ${res.statusCode}');
  retorno = res.body;
  print(retorno);
  token = retorno['token'];
  return token;
}
}