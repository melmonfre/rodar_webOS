import 'package:flutter/material.dart';

class ListaItens extends StatelessWidget {

  late final String antesLuzesPainelInstrumento;
  late final String antesArCondicionado;
  // Adicione outras variáveis de antes aqui

  // ListaItens({required this.antesLuzesPainelInstrumento, required this.antesArCondicionado });




  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10, // Número total de itens na lista
      separatorBuilder: (context, index) => Divider(), // Divisor entre os itens
      itemBuilder: (context, index) {
        String antes = 'Antes $index'; // Valor antes
        String depois = 'Depois $index'; // Valor depois

        return ListTile(
          title: Text('Item $index'), // Descrição do item
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Antes: $antesLuzesPainelInstrumento'), // Valor antes
              Text('Depois: $antesArCondicionado'), // Valor depois
            ],
          ),
        );
      },
    );
  }
}
