
import 'package:rodarwebos/services/getToken.dart';
import 'package:uni_links/uni_links.dart';

class LinkHandler {
  String? linkExterno;

  Future<void> initUrlLaunch() async {
    try {
      // Verifica se o aplicativo foi aberto por um link externo
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        // Salva o link em uma variável
        linkExterno = initialLink;
        if (linkExterno != null) {
          var divid = linkExterno?.split("/auth/");
          print(divid);
          var token = divid?[1];
          // Imprime o link no console
          print('Link externo: $linkExterno');
          print('token $token');
          // getToken().obter(token);
        }
      }
    } catch (e) {
      // Ocorreu um erro ao acessar o link externo
      // Trate o erro conforme necessário
    }
  }
}





// import 'package:flutter/material.dart';
// import 'package:rodarwebos/services/getToken.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:uni_links/uni_links.dart';
// import 'package:flutter/services.dart' show PlatformException;
// import 'package:url_launcher/url_launcher.dart';

// // class LinkExterno extends StatelessWidget {
// //   const LinkExterno({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }

// class LinkHandler {
//   String? linkExterno;

//   Future<void> initUniLinks() async {
//     try {
//       // Verifica se o aplicativo foi aberto por um link externo
//       final Uri? initialLink = await getInitialUri();
//       if (initialLink != null) {
//         // Salva o link em uma variável
//         linkExterno = initialLink.toString();
//         if (linkExterno != null) {
//           var divid = linkExterno?.split("/auth/");
//           print(divid);
//           var token = divid?[1];
//           // Imprime o link no console
//           print('Link externo: $linkExterno');
//           print('token $token');
//           getToken().obter(token);
//         }
//       }
//     } on PlatformException {
//       // Ocorreu um erro ao acessar o link externo
//       // Trate o erro conforme necessário
//     }
//   }
// }