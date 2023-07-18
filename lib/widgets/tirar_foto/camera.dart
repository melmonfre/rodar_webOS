import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rodarwebos/pages/deslocamento/tela_deslocamento.dart';
import 'package:rodarwebos/widgets/botoes/botao_cancelar.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraButton extends StatefulWidget {
  @override
  _CameraButtonState createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> {
  List<File> _images = []; // Lista de arquivos de imagens selecionadas
  List<String> _imageNames = []; // Lista de nomes das imagens
  List<double> _imageSizes = []; // Lista de tamanhos das imagens
  List<String> base64Files =
      []; // Lista de strings base64 das imagens convertidas

  salvanocache(base64Files) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    opcs.setStringList("base64camera",
        base64Files); // Salva a lista de strings base64 no cache
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
        _images.add(image); // Adiciona a imagem à lista de imagens
        _imageNames
            .add(fileName); // Adiciona o nome do arquivo à lista de nomes
        _imageSizes.add(imageSize
            .toDouble()); // Adiciona o tamanho da imagem à lista de tamanhos
        createbase64(_images); // Converte as imagens em strings base64
      });

      // Salvar a imagem na galeria
      final directory = await getApplicationDocumentsDirectory();
      final index = _images.length - 1;
      final imagePath = '${directory.path}/image_$index.jpg';
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

  Widget _buildThumbnail(int index) {
    final image = _images[index]; // Imagem do índice especificado
    final imageName =
        _imageNames[index]; // Nome da imagem do índice especificado
    final imageSize =
        _getImageSize(index); // Tamanho da imagem do índice especificado

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
            onPressed: () => _clearPicture(
                index), // Chama a função para limpar a imagem ao clicar no botão de cancelar
            index: index,
          ),
        ],
      ),
    );
  }

  String _getImageSize(int index) {
    if (index >= 0 && index < _imageSizes.length) {
      final fileSize = _imageSizes[index] / 1024; // Tamanho em kilobytes
      return '${fileSize.toStringAsFixed(2)} KB'; // Retorna o tamanho formatado com duas casas decimais e a unidade "KB"
    } else {
      return ''; // Retorna uma string vazia se o índice estiver fora dos limites
    }
  }

  void _clearPicture(int index) {
    setState(() {
      if (index >= 0 && index < _images.length) {
        _images.removeAt(index); // Remove a imagem da lista
        _imageNames.removeAt(index); // Remove o nome da imagem da lista
        _imageSizes.removeAt(index); // Remove o tamanho da imagem da lista

        // Atualiza o índice da imagem nas demais imagens
        for (int i = index; i < _images.length; i++) {
          _imageNames[i] = _imageNames[i].replaceAll('image_$index',
              'image_$i'); // Substitui o índice antigo pelo novo no nome da imagem
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
          SizedBox(height: 16,),
          BotaoProximo(
            onPressed: () {
              if (_images.isNotEmpty) {
                // Avance para a próxima tela
              } else {
                // Exiba um alerta informando ao usuário para inserir pelo menos uma foto
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Alerta'),
                      content: Text('Por favor, insira pelo menos uma foto.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
  

  void createbase64(List<File> images) {
    images.forEach((image) {
      List<int> imageBytes = image.readAsBytesSync();
      String base64File = base64Encode(imageBytes);
      base64Files.add(base64File);
    });
    salvanocache(base64Files);
  }
}
