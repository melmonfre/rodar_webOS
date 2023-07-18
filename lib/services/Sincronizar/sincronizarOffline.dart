import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../Constantes/Urlconst.dart';
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
    List<Arquivo> files = [];
    var file = Arquivo(base64: "", referencia: "", remover: 0, indice: 0, etapa: "");
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
    tecnico = element['tecnico'];

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
        equitec.tecnico = tecnico;
        equitec.localInstalacaoTec = "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentosRemovidoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "RETIRADA";
        equipamento.equipamentoTec = equitec;


      }else if(eqs["control"] == "INSTALACAO"){
        equitec.id =  eqs['EquipamentoInstaladoID'];
        equitec.numero = "";
        equitec.codigo = "${eqs['EquipamentoInstaladoCodigo']}";
        equitec.documento = "${eqs['EquipamentoInstaladoDocumento']}";
        equitec.status = "DISPONIVEL";
        equitec.cancelado = false;
        equitec.tecnico = tecnico;
        equitec.localInstalacaoTec = "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentoInstaladoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "INSTALACAO";
        equipamento.equipamentoTec = equitec;
      } else if(eqs["control"] == "TROCA"){
        equitec.id =  eqs['EquipamentoInstaladoID'];
        equitec.numero = "";
        equitec.codigo = "${eqs['EquipamentoInstaladoCodigo']}";
        equitec.documento = "${eqs['EquipamentoInstaladoDocumento']}";
        equitec.status = "DISPONIVEL";
        equitec.cancelado = false;
        equitec.tecnico = tecnico;
        equitec.localInstalacaoTec = "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentoInstaladoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "TROCA";
        equipamento.equipamentoTec = equitec;
      } else {
        equitec.id =  eqs['EquipamentosRemovidoID'];
        equitec.numero = "";
        equitec.codigo = "${eqs['EquipamentoRemovidoCodigo']}";
        equitec.documento = "${eqs['EquipamentoRemovidoDocumento']}";
        equitec.status = "INSTALADO";
        equitec.cancelado = false;
        equitec.tecnico = tecnico;
        equitec.localInstalacaoTec = "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentosRemovidoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "MANUTENCAO";
        equipamento.equipamentoTec = equitec;
      }
      jsonconclusao.acessorios.id = equipamento.id = eqs['EquipamentosRemovidoID'];
      jsonconclusao.acessorios.etapaApp = "ACESSORIOS";
      jsonconclusao.acessorios.acessorios = [];
    });
    jsonconclusao.equipamentos.id = osid;
    jsonconclusao.equipamentos.etapaApp = "SERVICO_INICIADO";

    List referencias = opcs.getStringList('referencias')!;
    var indice = 0;
    referencias.forEach((foto) {

      List fotos = opcs.getStringList("$foto")!;
      fotos.forEach((ft) {
        file.referencia = foto;
        file.base64 = ft;
        file.etapa = "FOTOS";
        file.remover =0;
        file.indice = indice;
        indice ++;
        files.add(file);
      });
    });

    jsonconclusao.arquivos.arquivos = files;
    var dadosdeslocamento = opcs.getString("dadosdeslocamento");
    var desloc = jsonDecode(dadosdeslocamento!);
    var DistanciaTec = desloc['distanciaPercorrida'];
    var valorDeslocamentoTec = desloc['valor'];
    var pedagioTec = desloc['pedagio'];
    var motivoDiv = desloc['motivoDiv'];

    jsonconclusao.deslocamento.etapa = "DESLOCAMENTO";
    jsonconclusao.deslocamento.pedagioTec = pedagioTec;
    jsonconclusao.deslocamento.distanciaTec = DistanciaTec;
    jsonconclusao.deslocamento.motivoDiv = motivoDiv;
    jsonconclusao.deslocamento.valorDeslocamentoTec = valorDeslocamentoTec;


    var mots = opcs.getString("motivositens");
    jsonconclusao.motivosManutencao.motivos = jsonDecode(mots!);
    var itensconcjson = opcs.getString("conclusaoItens");
    var itenscon = jsonDecode(itensconcjson!);

    jsonconclusao.dados.etapa = "CONCLUSAO";
    jsonconclusao.dados.hodometro = itenscon["hodometro"];
    jsonconclusao.dados.dataConclusaoOs = itenscon["dataConclusao"];
    jsonconclusao.dados.observacaoOs = "${itenscon["observacoes"]}";


    var datacon = opcs.getString("DadosContato");
    var contato = jsonDecode(datacon!);
    var assinatura = opcs.getString("assinaturaresponsavel");
    var base64 = opcs.getString("assinaturaconfirmacao");

    var tipoenvio;
    if (contato['responsavelAusente']){
      tipoenvio = "email";
      jsonconclusao.presencial = false;
    } else{
      tipoenvio = "presencial";
      jsonconclusao.presencial = true;
    }
    jsonconclusao.confirmacaoPresencial.etapa = "CONCLUSAO";
    jsonconclusao.confirmacaoPresencial.id = contato['id'];
    jsonconclusao.confirmacaoPresencial.nome = contato['nome'];
    jsonconclusao.confirmacaoPresencial.email = contato['email'];
    jsonconclusao.confirmacaoPresencial.telefone = contato['telefone'];
    jsonconclusao.confirmacaoPresencial.tipoEnvio =  tipoenvio;
    jsonconclusao.confirmacaoPresencial.idOs = osid;
    jsonconclusao.confirmacaoPresencial.documento = "";
    jsonconclusao.confirmacaoPresencial.referencia = "";
    jsonconclusao.confirmacaoPresencial.assinatura = base64!;
    jsonconclusao.confirmacaoPresencial.observacaoCliente = "";

    jsonconclusao.assinaturaResponsavel.etapa = "ASSINATURA_RESPONSAVEL";
    jsonconclusao.assinaturaResponsavel.id = contato['id'];
    jsonconclusao.assinaturaResponsavel.nome = contato['nome'];
    jsonconclusao.assinaturaResponsavel.email = contato['email'];
    jsonconclusao.assinaturaResponsavel.telefone = contato['telefone'];
    jsonconclusao.assinaturaResponsavel.tipoEnvio =  tipoenvio;
    jsonconclusao.assinaturaResponsavel.idOs = osid;
    jsonconclusao.assinaturaResponsavel.documento = "";
    jsonconclusao.assinaturaResponsavel.referencia = "";
    jsonconclusao.assinaturaResponsavel.assinatura = assinatura!;
    jsonconclusao.assinaturaResponsavel.observacaoCliente = "";

    jsonconclusao.documentosResponsavel.documentoFrente = jsonconclusao.assinaturaResponsavel;
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
    opcs.setString("${osid}@OSaFinalizardata", jsonEncode(jsonconclusao));
  }
  enviar(osid)async{
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = opcs.getString("${osid}@OSaFinalizardata");
    final url = Uri.parse('${Urlconst().url}ordem_servico/sincronizacaoordemservico');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200){
      List<String>? ids = opcs.getStringList("osIDaFinalizar");
      if(ids == null){
        ids = [];
        ids.add("$osid");
      }
      opcs.setStringList("osIDaFinalizar", ids);
      throw Exception('http.post error: statusCode= $status');
    } else{
      opcs.remove("${osid}@OSaFinalizardata");
      List<String>? ids = opcs.getStringList("osIDaFinalizar");
      ids?.remove(osid);
      opcs.setStringList("osIDaFinalizar", ids!);
    }
    print(res.body);
  }
}

