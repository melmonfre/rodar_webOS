import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as img;

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _imageFile;

  Future<void> _takePicture() async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(
    source: ImageSource.camera,
    maxWidth: 600,
  );

  if (pickedFile != null) {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(pickedFile.path);

    // Redimensiona a imagem para 800x600
    final bytes = await pickedFile.readAsBytes();
    final image = img.decodeImage(bytes)!;
    final resizedImage = img.copyResize(image, width: 600, height: 600);

    // Salva a imagem redimensionada na galeria
    final savedImage = File('${appDir.path}/$fileName');
    await savedImage.writeAsBytes(img.encodeJpg(resizedImage));

    // Salva a imagem na galeria
    await GallerySaver.saveImage(savedImage.path);

    setState(() {
      _imageFile = savedImage;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Tirar foto'),
            ),
          ],
        ),
      ),
    );
  }
}
