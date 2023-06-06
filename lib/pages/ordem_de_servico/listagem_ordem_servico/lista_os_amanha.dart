import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/ordem_de_servico/ordem_servico.dart';
import 'package:rodarwebos/widgets/botoes/botoes_os.dart';
import 'package:rodarwebos/widgets/menu_inicial/containers/containers_os/containers_os.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaOSAmanha extends StatefulWidget {
  @override
  _ListaOSAmanhaState createState() => _ListaOSAmanhaState();
}

class _ListaOSAmanhaState extends State<ListaOSAmanha> {
  var empresaid;
  var json;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    empresaid = opcs.getInt("sessionid");
    json = opcs.getString("${empresaid}@GetOSAmanha");
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
            Navigator.pop(context);
          },
        ),
        title: Text('OS Amanha'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContainerOS(

              botao: BotaoAmanha(),
            ),
            SizedBox(height: 0.2),
          ],
        ),
      ),
    );
  }
}
