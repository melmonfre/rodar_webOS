import 'package:flutter/material.dart';

class BotaoProximo extends StatefulWidget {

 final VoidCallback onPressed;

  const BotaoProximo({required this.onPressed});

  @override
  _BotaoProximoState createState() => _BotaoProximoState();

}

class _BotaoProximoState extends State<BotaoProximo> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20.0,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            primary: Color(0xFF00204E), // Cor do botão
            shadowColor: Colors.black.withOpacity(0.2), // Cor da sombra
            elevation: 4.0, // Elevação da sombra
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0), // Border radius do botão
            ),
          ),
          child: Text(
            'Próximo',
            style: TextStyle(
              color: Colors.white, // Cor do texto
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
