import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/visita_frustada/visita_frustada_resumo.dart';

class BotaoVisitaFrustada extends StatefulWidget {
  @override
  _BotaoVisitaFrustadaState createState() => _BotaoVisitaFrustadaState();
}

class _BotaoVisitaFrustadaState extends State<BotaoVisitaFrustada> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VisitaFrustadaResumo()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFE8716F), // Cor do botão
        shadowColor: Colors.black.withOpacity(0.2), // Cor da sombra
        elevation: 4.0, // Elevação da sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Border radius do botão
        ),
      ),
      child: Text(
        'Informar Visita Frustada',
        style: TextStyle(
          color: Colors.white, // Cor do texto
          fontSize: 13.0,
        ),
      ),
    );
  }
}
