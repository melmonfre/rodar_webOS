import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'JsonConclusao.dart';

class syncoff{
  //getters para instanciar o model
  get checkin => null;
  get equipamentos => null;
  get acessorios => null;
  get arquivos => null;
  get deslocamento => null;
  get checkout => null;
  get motivosManutencao => null;
  get dados => null;
  get assinaturaTecnico => null;
  get presencial => null;
  get notificacaoResponsavel => null;
  get confirmacaoPresencial => null;
  get documentosResponsavel => null;
  get assinaturaResponsavel => null;

  criarjson() async {
    // shared prefference pra obter dados do cache
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<CheckinIten> listcheckin = [];
    List<CheckoutIten> listcheckout = [];
    List<Equipamento> listequipamento = [];
    List<Telefone> tel = [];
    var jsonconclusao = JsonConclusao(checkin: checkin, equipamentos: equipamentos, acessorios: acessorios, arquivos: arquivos, deslocamento: deslocamento, checkout: checkout, motivosManutencao: motivosManutencao, dados: dados, assinaturaTecnico: assinaturaTecnico, presencial: presencial, notificacaoResponsavel: notificacaoResponsavel, confirmacaoPresencial: confirmacaoPresencial, documentosResponsavel: documentosResponsavel, assinaturaResponsavel: assinaturaResponsavel);
    var checkinitem = CheckinIten(id: 0, descricao: '', situacaoAntes: 0);
    var checkoutitem = CheckoutIten(id: 0, descricao: '', situacaoDepois: 0);
    var telefone = Telefone(id: 0, tipo: 0, ddi: "", ddd: "", numero: "", obs: "", telefoneCompleto: "");
    var estado = Estado(id: 0, sigla: "", nome: "");
    var cidade = Cidade(id: 0, nome: "", estado: estado);
    var endereco = Endereco(id: 0, rua: "", numero: "", bairro: "", complemento: "", cidade: cidade, cep: "", coordenadas: "");
    var empr = Empresa(id: 0, nome: "", email: "", telefones: tel, endereco: endereco, stringTelefone: "", cnpj: "");
    var pess = Pessoa(id: 0, empresa: empr);
    var tecnico = Tecnico(id: 0, pessoa: pess, valorHora: 0, kmAtendimento: 0, funcionario: true);
    var equitec = EquipamentoTec(id: 0, numero: "0", codigo: "0", documento: "0", status: "0", cancelado: false, tecnico: tecnico, localInstalacaoTec: "");
    var equipamento = Equipamento(id: 0, tipoTec: "", situacaoTec: true, equipamentoTec: equitec);

    var latitude;
    var longitude;
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    var  osid = element['id'];
    var jsoncheckin = opcs.getString("checkinitens");
    var datacheckin = jsonDecode(jsoncheckin!);
    var idcheckin = await datacheckin['idscheckin'];
    var nomescheckin = datacheckin['nomescheckin'];
    var itenscheckin = datacheckin['itenscheckin'];
    var obscheckin = datacheckin['obscheckin'];
    var jsoncheckout = opcs.getString("checkoutitens");
    var datacheckout = jsonDecode(jsoncheckout!);
    var itenscheckout = datacheckout['itenscheckin'];
    String? obsadc = opcs.getString("obscheckin");

    // preenchendo check-in e check-out
    for(int i = 0; i < idcheckin.length; i++){
      checkinitem.descricao = nomescheckin[i];
      checkinitem.id = idcheckin[i];
      checkinitem.situacaoAntes = itenscheckin[i];

      listcheckin.add(checkinitem);

      checkoutitem.descricao = nomescheckin[i];
      checkoutitem.id = idcheckin[i];
      checkoutitem.situacaoDepois = itenscheckout[i];
      listcheckout.add(checkoutitem);
    }
    jsonconclusao.checkin.itens = listcheckin;
    jsonconclusao.checkin.localGps = "$latitude,$longitude";
    jsonconclusao.checkin.etapa = "SERVICO_INICIADO";
    jsonconclusao.checkin.observacao = "$obsadc";
    jsonconclusao.checkout.itens = listcheckout;
    jsonconclusao.checkout.localGps = "$latitude,$longitude";
    jsonconclusao.checkout.etapa = "DESLOCAMENTO";



    // preenchendo equipamentos
    var jsoneqs = opcs.getStringList("EQProcess");
    jsoneqs?.forEach((element) {
      var eqs = jsonDecode(element);
      /*"EquipamentoInstaladoID": ,
    "EquipamentoInstaladoCodigo": ,
    "EquipamentosRemovidoID": "",
    "EquipamentoRemovidoCodigo": "",
    "localInstalacao": localInstalacao,*/
      if(eqs["control"] == "RETIRADA"){
        equitec.id =  eqs['EquipamentosRemovidoID'];
        equitec.numero = "";
        equitec.codigo = "${eqs['EquipamentoRemovidoCodigo']}";
        equitec.documento = "${eqs['EquipamentoRemovidoDocumento']}";
        equitec.status = "INSTALADO";
        equitec.cancelado = false;

        equipamento.id = eqs['EquipamentosRemovidoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "RETIRADA";

      }

    });



    jsonconclusao.equipamentos.id = osid;
    jsonconclusao.equipamentos.etapaApp = "SERVICO_INICIADO";

    /*
    required Checkin checkin,
    required Equipamentos equipamentos,
    required Acessorios acessorios,
    required Arquivos arquivos,
    required Deslocamento deslocamento,
    required Checkout checkout,
    required MotivosManutencao motivosManutencao,
    required Dados dados,
    required AssinaturaTecnico assinaturaTecnico,
    required bool presencial,
    required NotificacaoResponsavel notificacaoResponsavel,
    required AssinaturaResponsavel confirmacaoPresencial,
    required DocumentosResponsavel documentosResponsavel,
    required AssinaturaResponsavel assinaturaResponsavel,
     */



  }
}

