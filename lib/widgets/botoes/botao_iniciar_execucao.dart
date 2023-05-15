import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/check_in/tela_check_in.dart';

class BotaoIniciarExecucaoServico extends StatefulWidget {
  @override
  _BotaoIniciarExecucaoServicoState createState() =>
      _BotaoIniciarExecucaoServicoState();
}

class _BotaoIniciarExecucaoServicoState
    extends State<BotaoIniciarExecucaoServico> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckInTela()),
        );
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF00204E), // Cor do botão
        shadowColor: Colors.black.withOpacity(0.2), // Cor da sombra
        elevation: 4.0, // Elevação da sombra
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0), // Border radius do botão
        ),
      ),
      child: Center(
        child: Text(
          'Iniciar Execução de Serviço',
          style: TextStyle(
            color: Colors.white, // Cor do texto
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}
