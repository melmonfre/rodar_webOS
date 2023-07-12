import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class getequipamentos{
   get() async {
    var json;
    var element;
    var os;
    SharedPreferences opcs = await SharedPreferences.getInstance();
    json = opcs.getString("SelectedOS");
    element = jsonDecode(json);
    os = element['id'];
    List eqnovos = element['equipamentos'];
    List eqnovosid =[];
    List<String> eqnovoscod =[];
    List<String> eqnovodoc = [];
    var localInstalacao;
    var stringEquipamento;
    try{
      eqnovos.forEach((eq) {
        localInstalacao = eq['localInstalacao'];
        stringEquipamento = eq['stringEquipamento'];
        var equip = eq['equipamento'];
        eqnovosid.add(equip['id']);
        eqnovoscod.add(equip['codigo']);
        eqnovodoc.add(equip['documento']);
      });
    } catch(Exception) {
    }



    List acessorios =element['acessorios'];
    List accid =[];
    List acdesc =[];
    try{
      acessorios.forEach((acc) {
        var acess = acc['acessorio'];
        accid.add(acess['id']);
        acdesc.add(acess['descricao']);
      });
    } catch(Exception) {
    }


    var veiculo = element['veiculo'];
    List eqveiculo =veiculo["equipamentos"];
    List eqveiculoid =[];
    List eqveiculoDoc =[];
    List<String> eqveiculocod =[];
    try{eqveiculo.forEach((eq) {
      eqveiculoid.add(eq['id']);
      eqveiculocod.add(eq['codigo']);
      eqveiculoDoc.add(eq['documento']);
    });} catch(Exception) {
    }

   var equipamentos = {
      "EquipamentoNovoIDs": eqnovosid,
      "EquipamentoNovoCodigos": eqnovoscod,
      "EquipamentoNovoDocumento": eqnovodoc,
      "AcessoriosID":accid,
      "AcessoriosDescricao":acdesc,
      "EquipamentosVeiculoIDs":eqveiculoid,
      "EquipamentoVeiculoCodigos": eqveiculocod,
      "EquipamentoVeiculoDocumento": eqveiculoDoc,
      "localInstalacao" : localInstalacao,
      "stringEquipamento": stringEquipamento,
    };
   opcs.setString("equipamentos", jsonEncode(equipamentos));
  }
  setEquipamento(Map<String, dynamic> equip) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    var eqp = jsonEncode(equip);
    List<String>? eqlist = opcs.getStringList("EQProcess");
    eqlist?.add(eqp);
    opcs.setStringList("EQProcess", eqlist!);

/*    Map<String, dynamic> equipamentos = {

      "EquipamentoInstaladoID": eqnovosid,
      "EquipamentoInstaladoCodigo": selecionadonovo,
      "EquipamentosRemovidoID":eqremovid,
      "EquipamentoRemovidoCodigo": selecionadoveiculo,
      "localInstalacao" : localInstalacao,
    };*/
  }

}