import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rodarwebos/pages/responsavel/tela_responsavel.dart';
import 'package:rodarwebos/widgets/foto_assinatura/assinatura.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

class Imagem extends StatefulWidget {
  final VoidCallback onPressed;

  Imagem({required this.onPressed});

  @override
  _ImagemState createState() => _ImagemState();
}

class _ImagemState extends State<Imagem> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    // exportBackgroundColor: Colors.transparent,
    exportBackgroundColor: Colors.white,
  );
  Uint8List? data;

  Future<void> _criarImagem(context) async {
    Uint8List result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Assinatura(_controller),
      ),
    );
    setState(() {
      data = result;
    });
    createbase64(data);
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

  void createbase64(image) {
    List<int> imageBytes = image;
    String base64File = base64Encode(imageBytes);
    print("BASE64 $base64File");
    salvanocache(base64File);
  }

  salvanocache(base64Files) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("base64assinatura", base64Files);
  }

  void _limparAssinatura() {
    _controller.clear();

    Fluttertoast.showToast(
      msg: 'Assinatura salva com sucesso',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600, // Defina a altura desejada para o widget Imagem
      child: Scaffold(
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
        floatingActionButton: null,
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Color(0xFF00204E),
          child: SizedBox(
            height: 48.0,
            child: TextButton(
              onPressed: () {
                _limparAssinatura();
                widget.onPressed();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              child: Text(
                'Próximo',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
