import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/deslocamento/visita_frustada_deslocamento.dart';
import 'package:rodarwebos/services/salvaFotos.dart';
import 'package:rodarwebos/widgets/anexos/anexo_evidencias.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VisitaFrustadaAnexo extends StatefulWidget {
  @override
  _VisitaFrustadaAnexoState createState() => _VisitaFrustadaAnexoState();
}

class _VisitaFrustadaAnexoState extends State<VisitaFrustadaAnexo> {


  int num =0;

  var element;
  var json;
  var os;
  Future<void> getdata() async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    setState(() {
      os;
    });
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
          title: Text('Visita frustada'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$os",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                AnexoEvidencias(
                  titulo: 'Anexar Evidências',
                  onPressed: () {
                    salvarfotos().save("base64vf");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VisitaFrustadaDeslocamento(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }

}
