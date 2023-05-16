import 'package:flutter/material.dart';
import 'package:rodarwebos/pages/conclusao/tela_conclusao.dart';
import 'package:rodarwebos/widgets/botoes/botao_proximo.dart';

class ContainerRelateMotivos extends StatefulWidget {
  @override
  _ContainerRelateMotivosState createState() => _ContainerRelateMotivosState();
}

class _ContainerRelateMotivosState extends State<ContainerRelateMotivos> {
  bool isInconclusivo = false;
  bool isProblemaPosChave = false;
  bool isMalContatoChicote = false;
  bool isEquipamentoUmidade = false;
  bool isConectoresFolga = false;
  bool isEquipamentoSemEnergia = false;
  bool isBateriaNaoSegura = false;
  bool isProblemaAntenaGPS = false;
  bool isFioAterramentoSolto = false;
  bool isInterferenciaEletrica = false;
  bool isRastreadorSemFuncionar = false;

  bool _hasSelectedCheckbox() {
  return isInconclusivo ||
      isProblemaPosChave ||
      isMalContatoChicote ||
      isEquipamentoUmidade ||
      isConectoresFolga ||
      isEquipamentoSemEnergia ||
      isBateriaNaoSegura ||
      isProblemaAntenaGPS ||
      isFioAterramentoSolto ||
      isInterferenciaEletrica ||
      isRastreadorSemFuncionar;
}


  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(5.0),
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
            padding: EdgeInsets.all(10.0),
            child: Column(children: [
              Text(
                "Relate os motivos",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CheckboxListTile(
                title: Text("Inconclusivo"),
                value: isInconclusivo,
                onChanged: (newValue) {
                  setState(() {
                    isInconclusivo = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Problema pós-chave"),
                value: isProblemaPosChave,
                onChanged: (newValue) {
                  setState(() {
                    isProblemaPosChave = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Mal contato no chicote"),
                value: isMalContatoChicote,
                onChanged: (newValue) {
                  setState(() {
                    isMalContatoChicote = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Equipamento com umidade"),
                value: isEquipamentoUmidade,
                onChanged: (newValue) {
                  setState(() {
                    isEquipamentoUmidade = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Conectores com folga"),
                value: isConectoresFolga,
                onChanged: (newValue) {
                  setState(() {
                    isConectoresFolga = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Equipamento sem energia"),
                value: isEquipamentoSemEnergia,
                onChanged: (newValue) {
                  setState(() {
                    isEquipamentoSemEnergia = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Bateria do equipamento não segura"),
                value: isBateriaNaoSegura,
                onChanged: (newValue) {
                  setState(() {
                    isBateriaNaoSegura = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Problema na antena do GPS"),
                value: isProblemaAntenaGPS,
                onChanged: (newValue) {
                  setState(() {
                    isProblemaAntenaGPS = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Fio de aterramento solto"),
                value: isFioAterramentoSolto,
                onChanged: (newValue) {
                  setState(() {
                    isFioAterramentoSolto = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Interferência elétrica do veículo"),
                value: isInterferenciaEletrica,
                onChanged: (newValue) {
                  setState(() {
                    isInterferenciaEletrica = newValue ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text("Rastreador sem funcionar"),
                value: isRastreadorSemFuncionar,
                onChanged: (newValue) {
                  setState(() {
                    isRastreadorSemFuncionar = newValue ?? false;
                  });
                },
              ),
              SizedBox(height: 10.0),
              BotaoProximo(onPressed: () {
                if (!_hasSelectedCheckbox()) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Aviso'),
                          content: Text(
                              'Selecione pelo menos um motivo antes de prosseguir'),
                          actions: [
                            TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ],
                        );
                      });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TelaConclusao()),
                  );
                }
              },),
            ]),
            
          ),
          
        ) 
        
        
        
        );

        
  }
}
