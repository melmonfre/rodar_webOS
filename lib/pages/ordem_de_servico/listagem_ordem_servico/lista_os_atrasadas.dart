import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/botoes/botoes_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/containers_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../tela_inicial/tela_inicial.dart';

class ListaOSAtrasadas extends StatefulWidget {
  @override
  _ListaOSAtrasadasState createState() => _ListaOSAtrasadasState();
}

class _ListaOSAtrasadasState extends State<ListaOSAtrasadas> {
  var empresaid;
  var json;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    json = opcs.getString("${empresaid}@GetOSAtrasadas");
    opcs.setString("SessionOS", json);
    opcs.setString("listaGrupo", "atrasadas");
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
            Navigator.of(context).pop();
          },
        ),
        title: Text('OS Atrasadas'),
      ),
      body: Container(
        child: ContainerOS(
          botao: BotaoAtrasado(),
        ),
      ),
    );
  }
}
