import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodarwebos/widgets/botoes/botao_cancelar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraButton extends StatefulWidget {
  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  List<File> _images = [];
  List<String> _imageNames = [];
  List<double> _imageSizes = [];
  List<String> base64Files = [];
salvanocache(base64Files) async {
  SharedPreferences opcs = await SharedPreferences.getInstance();
  opcs.setStringList("base64camera", base64Files);
}

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      final image = File(pickedFile.path);
      final imageSize = await image.length();

      final fileName = pickedFile.path
          .split('/')
          .last; // Obter o nome do arquivo corretamente
      setState(() {
        _images.add(image);
        List<int> imageBytes = image.readAsBytesSync();
        String base64File = base64Encode(imageBytes);

        base64Files.add(base64File);
        salvanocache(base64Files);
        _imageNames.add(fileName);
        _imageSizes.add(imageSize.toDouble());
      });

      // Salvar a imagem na galeria
      final directory = await getApplicationDocumentsDirectory();
      final index = _images.length - 1;
      final imagePath = '${directory.path}/image_$index.jpg';
      await image.copy(imagePath);
    }
  }

  String _truncateFileName(String fileName) {
    const maxLength = 10;
    const lineBreakAt = 5;

    if (fileName.length <= maxLength) {
      return fileName;
    } else {
      final extensionIndex = fileName.lastIndexOf('.');
      final name = fileName.substring(0, extensionIndex);
      final extension = fileName.substring(extensionIndex);
      final truncatedName = name.substring(0, lineBreakAt) +
          '\n' +
          name.substring(lineBreakAt, maxLength - extension.length);
      return truncatedName + '...' + extension;
    }
  }

  Widget _buildThumbnail(int index) {
    final image = _images[index];
    final imageName = _imageNames[index];
    final imageSize = _getImageSize(index);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            image,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '',
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  _truncateFileName(imageName),
                  style: TextStyle(fontSize: 11),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 1),
          Text(
            imageSize,
            style: TextStyle(fontSize: 11),
          ),
          SizedBox(width: 5),
          BotaoCancelar(
            onPressed: () => _clearPicture(index),
            index: index,
          ),
        ],
      ),
    );
  }

  String _getImageSize(int index) {
    if (index >= 0 && index < _imageSizes.length) {
      final fileSize = _imageSizes[index] / 1024; // Tamanho em kilobytes
      return '${fileSize.toStringAsFixed(2)} KB';
    } else {
      return '';
    }
  }

  void _clearPicture(int index) {
    setState(() {
      if (index >= 0 && index < _images.length) {
        _images.removeAt(index);
        _imageNames.removeAt(index);
        _imageSizes.removeAt(index);

        // Atualiza o índice da imagem
        for (int i = index; i < _images.length; i++) {
          _imageNames[i] =
              _imageNames[i].replaceAll('image_$index', 'image_$i');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Selecione uma opção',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            GestureDetector(
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  Text('Tirar foto'),
                                ],
                              ),
                              onTap: () {
                                _takePicture(ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              child: Row(
                                children: [
                                  SizedBox(width: 8),
                                  Text('Galeria'),
                                ],
                              ),
                              onTap: () {
                                _takePicture(ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              icon: Icon(Icons.camera),
              label: Text('Tirar foto'),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height *
                0.5, // Ajuste a altura conforme necessário
            child: ListView.builder(
              shrinkWrap:
                  true, // Limita a altura do ListView ao conteúdo disponível
              itemCount: _images.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    _buildThumbnail(index),
                    SizedBox(height: 12), // Espaçamento entre os itens
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
