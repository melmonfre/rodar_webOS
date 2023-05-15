import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:rodarwebos/widgets/drawer/drawer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:flutter/services.dart';
import 'package:rodarwebos/widgets/assinatura/assinatura.dart';

class AssinaturaPage extends StatefulWidget {
  @override
  _AssinaturaPageState createState() => _AssinaturaPageState();
}

class _AssinaturaPageState extends State<AssinaturaPage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    //exportBackgroundColor: Colors.transparent, // removido
    exportBackgroundColor: Colors.white,
  );
  Uint8List? data;

  Future<void> _criarImagem(context) async {
    Uint8List? result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (BuildContext context) => Assinatura(_controller)),
    );
    setState(() {
      data = result;
    });

    _salvarImagemNaGaleria(data);
  }

  void _salvarImagemNaGaleria(Uint8List? pngBytes) async {
    final directory = (await getApplicationDocumentsDirectory()).path;
    File imgFile = File('$directory/photo.png');
    await imgFile.writeAsBytes(pngBytes!);

    if (imgFile.path != null) {
      GallerySaver.saveImage(imgFile.path).then((a) {
        print('salvo');
      });
    }
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
        title: Text('Assinatura'),
      ),
      // drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                _criarImagem(context);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.black87, width: 2.0),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(2.0),
                  child: data != null
                      ? Image.memory(data!)
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Clique aqui para assinar"),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

