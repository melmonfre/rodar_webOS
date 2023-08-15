import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botoes_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/containers_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tela_inicial/tela_inicial.dart';

class ListaOSFuturas extends StatefulWidget {
  @override
  _ListaOSFuturasState createState() => _ListaOSFuturasState();
}

class _ListaOSFuturasState extends State<ListaOSFuturas> {
  var empresaid;
  var json;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    json = opcs.getString("${empresaid}@GetOSFuturas");
    opcs.setString("SessionOS", json);
    print("JSON: $json");
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaInicial()),
            );
          },
        ),
        title: Text('OS Futuras'),
      ),
      body: Container(
        child: ContainerOS(
          botao: BotaoFuturas(),
        ),
      ),
    );
  }
}
