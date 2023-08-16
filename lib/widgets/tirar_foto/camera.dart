import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodarwebos/widgets/botoes/botao_cancelar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as Img;

class CameraButton extends StatefulWidget {
  final Function(bool) onFotoSelected;

  CameraButton({required this.onFotoSelected});
  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  File? _image; // Lista de arquivos de imagens selecionadas
  late String _imageName; // Lista de nomes das imagens
  late double _imageSize; // Lista de tamanhos das imagens
  late String base64File; // Lista de strings base64 das imagens convertidas

  salvanocache(base64Files) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setString("base64camera",
        base64Files); // Salva a lista de strings base64 no cache
    print("Foto $base64Files");
  }

  Future<void> _takePicture(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      var image = File(pickedFile.path);
      Img.Image? image_temp = Img.decodeImage(image.readAsBytesSync());
      if (image_temp != null) {
        Img.Image? resized_img =
            Img.copyResize(image_temp, width: 1024, height: 720);
        image = File(pickedFile.path)
          ..writeAsBytesSync(Img.encodeJpg(resized_img));
      }
      final imageSize = await image.length();

      final fileName = pickedFile.path
          .split('/')
          .last; // Obter o nome do arquivo corretamente
      setState(() {
        _image = image; // Define a imagem selecionada
        _imageName = fileName; // Define o nome da imagem selecionada
        _imageSize =
            imageSize.toDouble(); // Define o tamanho da imagem selecionada
        createbase64(_image); // Converte a imagem em string base64
      });
      widget.onFotoSelected(true);

      // Salvar a imagem na galeria
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/image.jpg';
      await image.copy(imagePath);
    }
  }

  String _truncateFileName(String fileName) {
    const maxLength = 10; // Comprimento máximo do nome do arquivo truncado
    const lineBreakAt =
        5; // Índice de quebra de linha no nome do arquivo truncado

    if (fileName.length <= maxLength) {
      return fileName; // Retorna o nome completo se for menor ou igual ao comprimento máximo
    } else {
      final extensionIndex = fileName.lastIndexOf('.');
      final name = fileName.substring(0, extensionIndex);
      final extension = fileName.substring(extensionIndex);
      final truncatedName = name.substring(0, lineBreakAt) +
          '\n' +
          name.substring(lineBreakAt, maxLength - extension.length);
      return truncatedName +
          '...' +
          extension; // Retorna o nome truncado com reticências e extensão
    }
  }

  Widget _buildThumbnail() {
    if (_image == null) {
      return SizedBox(); // Retorna um widget vazio se não houver imagem selecionada
    }

    final imageName =
        _image!.path.split('/').last; // Nome da imagem selecionada
    final imageSize = _getImageSize(_image);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            _image!,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ), // Exibe a imagem como miniatura
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '', // Texto vazio
                  style: TextStyle(fontSize: 11),
                ),
                Text(
                  _truncateFileName(
                      imageName), // Exibe o nome truncado da imagem
                  style: TextStyle(fontSize: 11),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 1),
          Text(
            imageSize, // Exibe o tamanho da imagem
            style: TextStyle(fontSize: 11),
          ),
          SizedBox(width: 5),
          BotaoCancelar(
            onPressed:
                _clearPicture, // Chama a função para limpar a imagem ao clicar no botão de cancelar
          ),
        ],
      ),
    );
  }

  String _getImageSize(File? image) {
    if (image != null) {
      final fileSize = image.lengthSync() / 1024; // Tamanho em kilobytes
      return '${fileSize.toStringAsFixed(2)} KB'; // Retorna o tamanho formatado com duas casas decimais e a unidade "KB"
    } else {
      return ''; // Retorna uma string vazia se a imagem estiver nula
    }
  }

  void _clearPicture() {
    setState(() {
      if (_image != null) {
        _image = null; // Remove a imagem selecionada
      }
      widget.onFotoSelected(false);
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
              onPressed: _image == null
                  ? () {
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
                    }
                  : null, // Define onPressed como null quando há uma imagem selecionada
              icon: Icon(Icons.camera),
              label: Text('Tirar foto'),
            ),
          ),
          SizedBox(height: 10),
          _image != null
              ? _buildThumbnail()
              : SizedBox(), // Exibe a foto selecionada ou um widget vazio
          SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  void createbase64(File? image) {
    if (image != null) {
      List<int> imageBytes = image.readAsBytesSync();
      base64File = base64Encode(imageBytes);
      print(base64File);
      salvanocache(base64File);
    } else {}
  }
}
