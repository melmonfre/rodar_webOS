import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/fotos/visita_frustada_anexo.dart';
import 'package:rodarwebos/widgets/botoes/botao_iniciar_execucao.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';
import 'package:rodarwebos/widgets/botoes/botao_visita_frustada.dart';
import 'package:rodarwebos/widgets/ordem_servico/variaveis_resumo_os.dart';

class VisitaFrustadaResumo extends StatefulWidget {
  @override
  _VisitaFrustadaResumoState createState() => _VisitaFrustadaResumoState();
}

class _VisitaFrustadaResumoState extends State<VisitaFrustadaResumo> {
  var variaveis = VariaveisResumo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Visita frustada'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  variaveis.numero_os.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados de Agendamento',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  variaveis.horario_agendamento,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Tempo de espera',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Não houve tempo de espera, agendamento marcado para ${variaveis.minutos} minutos',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Cliente',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cliente: ${variaveis.cliente}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Empresa: ${variaveis.empresa}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              // -----------------------------------------------------------
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Dados do Veiculo',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Placa: ${variaveis.placa}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cor: ${variaveis.cor}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chassi: ${variaveis.chassi}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Plataforma: ${variaveis.plataforma}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Modelo: ${variaveis.modelo}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ano: ${variaveis.ano}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Renavam: ${variaveis.renavam}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Serviços',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  variaveis.servicos,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              Container(
                height: 1.0,
                color: Colors.grey[500],
              ),
              SizedBox(height: 12.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Endereço',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  variaveis.endereco,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 40.0,
                    child: Center(
                      child: BotaoProximo(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisitaFrustadaAnexo()),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }
}
