import 'package:flutter/material.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class TelaSincronizar extends StatefulWidget {
  const TelaSincronizar({Key? key}) : super(key: key);

  @override
  State<TelaSincronizar> createState() => _TelaSincronizarState();
}

class _TelaSincronizarState extends State<TelaSincronizar> {
  @override
  Widget build(BuildContext context) {
    var variaveis = VariaveisResumo();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sincronizar'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centraliza os elementos verticalmente
          children: [
            SizedBox(height: 16.0),
            // Container com texto
            Container(
              alignment: Alignment.center,
              child: Text(
                'Testando com variável',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 24.0),
            // Container com texto
            Container(
              alignment: Alignment.center,
              child: Text(
                'texto teste',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 30.0),
            // Botão
            _BotaoSincronizar(),
          ],
        ),
      ),
    );
  }
}

class _BotaoSincronizar extends StatefulWidget {
  @override
  State<_BotaoSincronizar> createState() => _BotaoSincronizarState();
}

class _BotaoSincronizarState extends State<_BotaoSincronizar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 20.0,
        child: ElevatedButton(
          onPressed: () {
            // Função a ser executada ao pressionar o botão
          },
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
            'Sincronizar',
            style: TextStyle(
              color: Colors.white, // Cor do texto
              fontSize: 17.0,
            ),
          ),
        ),
      ),
    );
  }
}
