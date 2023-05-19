import 'package:http/http.dart' as http;
import 'package:rodarwebos/Constantes/Urlconst.dart';

class listOS{
  void obter() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJjdHkiOiJKV1QiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2IiwiYWxnIjoiZGlyIn0..v28D-R5mH9iZl8SblCPytg.XNz4qMvTbAbgCOYKBbPQ9HsnkkEra3lZHCzOkRkQuyZv6s7n1jAtUGZd_MNF0UrcRX_x_0BfB-PQ_7HX58MHpbNF8oWE8L9jql1tJbbcQ3NSQDwEykK5HaDORIcUiqrzMIzxgPLYX9zk7MSt8IpvGEHz8lf1hzohKSIRJibUj_AFXrSfWKbDTTvXPeEFoLyWRxjXLtvcej7sh0_MHMeQvP3EYrd6Dtu1QLuV1jhvZmlp_enEvriwgcJlwDYPgOP9YgdvRrw3-8RGW0tH4TjhCPO3r1X1SF0VfuuXNaWWBAmst6xaCAha8R1VtlDyXpzdARZOUG2Ws69SBPt_KOwRtkAVlJeC5maDIp1daMfWPOtRWjW2IgkSQWDZyMiZ6TVaTOb9PUFz15Z3oobU6frieRe6FmDCBTNZOlPC-JelY3RuIk8iy9iAa2ozMARIv-0K1nb9XuPkN-bodOWAeuDugggqlWryc-19FRqRSzp81bJab3zRZGF5XmtQfBJTLw8GjGSlGr53Jb46mtQwNv5kUrfKDRSloAstfQnYRNwgdLTCOGZP6DfSZKmsb0BsyWlveIJK8YR218NwWAC7UZdEB2wkB4OBfsb7oV-WHueRUMVyfg0L9fRNlUJR4Ppwl6c3lSzzyu-9RRHEopiLSMjF3adDUUmxUGGHRu70aJRU7qQsoMxQeZ_hy9xfOhujsggkeqVhOCD7sO_mARaJ0QCsAfXZC5Llza4eFeYsgnl3IM45wGeG4Xe0wNiIwy6-TEvLfMQXX6daxM_vXn68I63Cq9Xzn8P1ll4Ari19b31MLkReMdiSENFUZ0eQpQAp3CIS1prkYLZ9luN_B9B3TkRa1Rqk-hXoIceW7xf0Kw0ltHMqskdSwH4v_UaNzLoSp4D3kSnbiq1I9GjoVQjLEaN7mgEwPJMXZfdUEYtsVLJCWNVrTVGI-OqBO1UdD8kR5Iu2Q09w4Tf-nFLK3FnpWr9N4qhOw9UhQKj3fS1fWiECrgdUv_tH5JCobjJDFPns6E9rz9UVMAbDvRLhRLYXv-vICX0R_dapgISZTUO9hNMKqLmPxbMKt6qQNQ3AA6pBoSrXIdznNPGqie8wzjXQDVWe1H0f01pejFrVZ_82u8Ee7XvqW2ny6nCW5fdBWYfRMb8-5ecbFGsYAeyafEugNwu6xfAsrx-q0D9kEQKKe1g0Qelx4cZ7Ei9pk13LNPdHmTEbjs3cOFst8zuWhTlTadCQrjnrRSC7LEHvwqjRQ8wytidl8fu3IVBJWgj7DdmU0dc0CjAkpsrrvwqu7_DdJu40niODr-2chfCjlxx4Ty4I-N2eergwNVTy2Q3pzoSLog0Ir0glefquHfciBrKPdyxudg._aXQ4uRbXCCVPfr4cLM97w',
    };

    var data = '{\n  "value": {\n    "tipo": 0\n  },\n  "first": 0,\n  "rows": 10,\n  "sorts": [\n    {\n      "campo": "string",\n      "asc": true\n    }\n  ]\n}';

    var url = Uri.parse('${Urlconst().url}ordem_servico/list');
    var res = await http.post(url, headers: headers, body: data);
    if (res.statusCode != 200) throw Exception('http.post error: statusCode= ${res.statusCode}');
    print(res.body);
  }
}
