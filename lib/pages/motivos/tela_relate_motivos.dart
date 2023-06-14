import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/motivos/container_relate_motivos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RelateMotivo extends StatefulWidget {
  @override
  _RelateMotivoState createState() => _RelateMotivoState();
}

class _RelateMotivoState extends State<RelateMotivo> {

  var osid;
  Future<void> getdata() async {
    var json;
    var element;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    osid = element['id'];
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }
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
        title: Text('Motivos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text("$osid",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ContainerRelateMotivos()
            ],
          ),
        ),
      ),
    );
  }
}
