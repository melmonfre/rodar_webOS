import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/fotos/telas_fotos/foto_hodometro.dart';
import 'package:rodarwebos/widgets/acessorios/variaveis_acessorios.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';

class ContainerAcessoriosInstalados extends StatefulWidget {
  @override
  _ContainerAcessoriosInstaladosState createState() =>
      _ContainerAcessoriosInstaladosState();
}

class _ContainerAcessoriosInstaladosState
    extends State<ContainerAcessoriosInstalados> {
  var variaveis = VariaveisAcessorios();
  String? localInstalacao = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  'Acessórios instalados:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                variaveis.acess[2].toUpperCase(),
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Local de instalação',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    localInstalacao = value;
                  });
                },
              ),
              SizedBox(height: 18.0),
              BotaoProximo(
                onPressed: () {
                  if (localInstalacao != null) {
                    variaveis.localInstalacao = localInstalacao;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FotoHodometro()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Erro'),
                          content:
                              Text('Por favor, preencha todas as respostas.'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
