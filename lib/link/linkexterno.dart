import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart' show PlatformException;


// class LinkExterno extends StatelessWidget {
//   const LinkExterno({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class LinkHandler {
  String? linkExterno;

  Future<void> initUniLinks() async {
    try {
      // Verifica se o aplicativo foi aberto por um link externo
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        // Salva o link em uma variável
        linkExterno = initialLink;

        // Imprime o link no console
        print('Link externo: $linkExterno');
      }
    } on PlatformException {
      // Ocorreu um erro ao acessar o link externo
      // Trate o erro conforme necessário
    }
  }
}
