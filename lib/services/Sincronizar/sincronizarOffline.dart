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
    var jsonconclusao = JsonConclusao(checkin: checkin, equipamentos: equipamentos, acessorios: acessorios, arquivos: arquivos, deslocamento: deslocamento, checkout: checkout, motivosManutencao: motivosManutencao, dados: dados, assinaturaTecnico: assinaturaTecnico, presencial: presencial, notificacaoResponsavel: notificacaoResponsavel, confirmacaoPresencial: confirmacaoPresencial, documentosResponsavel: documentosResponsavel, assinaturaResponsavel: assinaturaResponsavel);
    var checkinitem = CheckinIten(id: 0, descricao: '', situacaoAntes: 0);
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


    jsonconclusao.checkin.etapa = "SERVICO_INICIADO";


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

