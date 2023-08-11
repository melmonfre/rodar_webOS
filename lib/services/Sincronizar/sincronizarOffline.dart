import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Constantes/Urlconst.dart';
import 'JsonConclusao.dart';

class syncoff {
  //getters para instanciar o model
  get checkin => Checkin();
  get equipamentos => Equipamentos();
  get acessorios => Acessorios();
  get arquivos => Arquivos();
  get deslocamento => Deslocamento();
  get checkout => Checkout();
  get motivosManutencao => MotivosManutencao();
  get dados => Dados();
  get assinaturaTecnico => AssinaturaTecnico();
  get presencial => true;
  get notificacaoResponsavel => NotificacaoResponsavel();
  get confirmacaoPresencial => AssinaturaResponsavel();
  get documentosResponsavel => DocumentosResponsavel();
  get assinaturaResponsavel => AssinaturaResponsavel();

  criarjson(osid) async {
    // shared prefference pra obter dados do cache
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<CheckinIten> listcheckin = [];
    List<CheckoutIten> listcheckout = [];
    List<Equipamento> listequipamento = [];
    List<Telefone> tel = [];
    List<Arquivo> files = [];
    var jsonconclusao = JsonConclusao(
        checkin: checkin,
        equipamentos: equipamentos,
        acessorios: acessorios,
        arquivos: arquivos,
        deslocamento: deslocamento,
        checkout: checkout,
        motivosManutencao: motivosManutencao,
        dados: dados,
        assinaturaTecnico: assinaturaTecnico,
        presencial: presencial,
        notificacaoResponsavel: notificacaoResponsavel,
        confirmacaoPresencial: confirmacaoPresencial,
        documentosResponsavel: documentosResponsavel,
        assinaturaResponsavel: assinaturaResponsavel);
    var telefone = Telefone(
        id: 0,
        tipo: 0,
        ddi: "",
        ddd: "",
        numero: "",
        obs: "",
        telefoneCompleto: "");
    var estado = Estado(id: 0, sigla: "", nome: "");
    var cidade = Cidade(id: 0, nome: "", estado: estado);
    var endereco = Endereco(
        id: 0,
        rua: "",
        numero: "",
        bairro: "",
        complemento: "",
        cidade: cidade,
        cep: "",
        coordenadas: "");
    var empr = Empresa(
        id: 0,
        nome: "",
        email: "",
        telefones: tel,
        endereco: endereco,
        stringTelefone: "",
        cnpj: "");
    var pess = Pessoa(id: 0, empresa: empr);
    var tecnico = Tecnico(
        id: 0, pessoa: pess, valorHora: 0, kmAtendimento: 0, funcionario: true);

    var latitude;
    var longitude;
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);
    latitude = position.latitude;
    longitude = position.longitude;
    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");
    var json = opcs.getString("SelectedOS");
    var element = jsonDecode(json!);
    tecnico = Tecnico.fromJson(element['tecnico']);

    var osid = element['id'];
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
    for (int i = 0; i < idcheckin.length; i++) {
      // acho que faltou enviar os dados da observação do checkin e do checkout
      listcheckin.add(CheckinIten(
          id: idcheckin[i],
          descricao: nomescheckin[i],
          situacaoAntes: itenscheckin[i]));
      listcheckout.add(CheckoutIten(
          id: idcheckin[i],
          descricao: nomescheckin[i],
          situacaoDepois: itenscheckout[i]));
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
    jsonconclusao.equipamentos.equipamentos = [];
    jsoneqs?.forEach((element) {
      var eqs = jsonDecode(element);
      var equipamento = Equipamento(
          id: 0,
          tipoTec: "",
          situacaoTec: true,
          equipamentoTec: EquipamentoTec(
              id: 0,
              numero: "0",
              codigo: "0",
              documento: "0",
              status: "0",
              cancelado: false,
              tecnico: tecnico,
              localInstalacaoTec: ""));

      /*"EquipamentoInstaladoID": ,
    "EquipamentoInstaladoCodigo": ,
    "EquipamentosRemovidoID": "",
    "EquipamentoRemovidoCodigo": "",
    "localInstalacao": localInstalacao,*/
      if (eqs["control"] == "RETIRADA") {
        equipamento.equipamentoTec?.id = eqs['EquipamentosRemovidoID'];
        equipamento.equipamentoTec?.numero = "";
        equipamento.equipamentoTec?.codigo =
            "${eqs['EquipamentoRemovidoCodigo']}";
        equipamento.equipamentoTec?.documento =
            "${eqs['EquipamentoRemovidoDocumento']}";
        equipamento.equipamentoTec?.status = "INSTALADO";
        equipamento.equipamentoTec?.cancelado = false;
        equipamento.equipamentoTec?.tecnico = tecnico;
        equipamento.equipamentoTec?.localInstalacaoTec =
            "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentosRemovidoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "RETIRADA";
        jsonconclusao.equipamentos.equipamentos?.add(equipamento);
      } else if (eqs["control"] == "INSTALACAO") {
        equipamento.equipamentoTec?.id = eqs['EquipamentoInstaladoID'];
        equipamento.equipamentoTec?.numero = "";
        equipamento.equipamentoTec?.codigo =
            "${eqs['EquipamentoInstaladoCodigo']}";
        equipamento.equipamentoTec?.documento =
            "${eqs['EquipamentoInstaladoDocumento']}";
        equipamento.equipamentoTec?.status = "DISPONIVEL";
        equipamento.equipamentoTec?.cancelado = false;
        equipamento.equipamentoTec?.tecnico = tecnico;
        equipamento.equipamentoTec?.localInstalacaoTec =
            "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentoInstaladoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "INSTALACAO";
        jsonconclusao.equipamentos.equipamentos?.add(equipamento);
      } else if (eqs["control"] == "TROCA") {
        equipamento.equipamentoTec?.id = eqs['EquipamentoInstaladoID'];
        equipamento.equipamentoTec?.numero = "";
        equipamento.equipamentoTec?.codigo =
            "${eqs['EquipamentoInstaladoCodigo']}";
        equipamento.equipamentoTec?.documento =
            "${eqs['EquipamentoInstaladoDocumento']}";
        equipamento.equipamentoTec?.status = "DISPONIVEL";
        equipamento.equipamentoTec?.cancelado = false;
        equipamento.equipamentoTec?.tecnico = tecnico;
        equipamento.equipamentoTec?.localInstalacaoTec =
            "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentoInstaladoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "TROCA";
        jsonconclusao.equipamentos.equipamentos?.add(equipamento);
      } else {
        equipamento.equipamentoTec?.id = eqs['EquipamentosRemovidoID'];
        equipamento.equipamentoTec?.numero = "";
        equipamento.equipamentoTec?.codigo =
            "${eqs['EquipamentoRemovidoCodigo']}";
        equipamento.equipamentoTec?.documento =
            "${eqs['EquipamentoRemovidoDocumento']}";
        equipamento.equipamentoTec?.status = "INSTALADO";
        equipamento.equipamentoTec?.cancelado = false;
        equipamento.equipamentoTec?.tecnico = tecnico;
        equipamento.equipamentoTec?.localInstalacaoTec =
            "${eqs['localInstalacao']}";

        equipamento.id = eqs['EquipamentosRemovidoID'];
        equipamento.situacaoTec = true;
        equipamento.tipoTec = "MANUTENCAO";
        jsonconclusao.equipamentos.equipamentos?.add(equipamento);
      }
      try {
        jsonconclusao.acessorios.id =
            equipamento.id = int.parse(eqs['EquipamentosRemovidoID']);
      } catch (e) {
        jsonconclusao.acessorios.id = 0;
      }
      jsonconclusao.acessorios.etapaApp = "ACESSORIOS";
      jsonconclusao.acessorios.acessorios = [];
    });
    jsonconclusao.equipamentos.id = osid;
    jsonconclusao.equipamentos.etapaApp = "SERVICO_INICIADO";

    List referencias = opcs.getStringList('referencias')!;
    print(referencias);
    var indice = 0;
    referencias.forEach((foto) {
      String? fotos = opcs.containsKey("$foto") ? opcs.getString("$foto") : "";
      files.add(Arquivo(
          base64: fotos,
          referencia: foto,
          remover: 0,
          indice: indice,
          etapa: "FOTOS"));
      indice++;
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
    print("MOTIVOS:");
    print(mots);
    var moti = jsonDecode(mots!);
    jsonconclusao.motivosManutencao.motivos = [];
    var idmotivos = moti['idsmotivos'];
    var itensmotivos = moti['itensmotivos'];
    for (int i = 0; i < idmotivos.length; i++) {
      if (itensmotivos[i]) {
        jsonconclusao.motivosManutencao.motivos?.add(idmotivos[i]);
      }
    }
    var itensconcjson = opcs.getString("conclusaoItens");
    var itenscon = jsonDecode(itensconcjson!);

    jsonconclusao.dados.etapa = "CONCLUSAO";
    jsonconclusao.dados.hodometro =
        itenscon["hodometro"] != "" ? double.parse(itenscon["hodometro"]) : 0;
    var conclu =
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(itenscon["dataConclusao"]);
    jsonconclusao.dados.dataConclusaoOs =
        DateFormat('yyyy-MM-ddTHH:mm:ss.SSS-03:00').format(conclu);
    jsonconclusao.dados.observacaoOs = "${itenscon["observacoes"]}";

    var datacon = opcs.getString("DadosContato");
    var contato = jsonDecode(datacon!);
    var assinatura = opcs.getString("assinaturaresponsavel");
    var base64 = opcs.getString("assinaturaconfirmacao");

    var tipoenvio;
    if (contato['responsavelAusente']) {
      tipoenvio = "email";
      jsonconclusao.presencial = false;
    } else {
      tipoenvio = "presencial";
      jsonconclusao.presencial = true;
    }
    jsonconclusao.confirmacaoPresencial.etapa = "CONCLUSAO";
    jsonconclusao.confirmacaoPresencial.id =
        contato['id'] != "" ? int.parse(contato['id']) : 0;
    jsonconclusao.confirmacaoPresencial.nome = contato['nome'];
    jsonconclusao.confirmacaoPresencial.email = contato['email'];
    jsonconclusao.confirmacaoPresencial.telefone = contato['telefone'];
    jsonconclusao.confirmacaoPresencial.tipoEnvio = tipoenvio;
    jsonconclusao.confirmacaoPresencial.idOs = osid;
    jsonconclusao.confirmacaoPresencial.documento = "";
    jsonconclusao.confirmacaoPresencial.referencia = "";
    jsonconclusao.confirmacaoPresencial.assinatura = base64!;
    jsonconclusao.confirmacaoPresencial.observacaoCliente = "";

    jsonconclusao.assinaturaResponsavel.etapa = "ASSINATURA_RESPONSAVEL";
    jsonconclusao.assinaturaResponsavel.id =
        contato['id'] != "" ? int.parse(contato['id']) : 0;
    jsonconclusao.assinaturaResponsavel.nome = contato['nome'];
    jsonconclusao.assinaturaResponsavel.email = contato['email'];
    jsonconclusao.assinaturaResponsavel.telefone = contato['telefone'];
    jsonconclusao.assinaturaResponsavel.tipoEnvio = tipoenvio;
    jsonconclusao.assinaturaResponsavel.idOs = osid;
    jsonconclusao.assinaturaResponsavel.documento = "";
    jsonconclusao.assinaturaResponsavel.referencia = "";
    jsonconclusao.assinaturaResponsavel.assinatura = assinatura!;
    jsonconclusao.assinaturaResponsavel.observacaoCliente = "";

    jsonconclusao.documentosResponsavel.documentoFrente =
        jsonconclusao.assinaturaResponsavel;
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
    //print(jsonEncode(jsonconclusao.checkin));
    // print(jsonEncode(jsonconclusao.equipamentos));
    // print(jsonEncode(jsonconclusao.acessorios));
    // print(jsonEncode(jsonconclusao.arquivos));
    // print(jsonEncode(jsonconclusao.deslocamento));
    // print(jsonEncode(jsonconclusao.checkout));
    // print(jsonEncode(jsonconclusao.motivosManutencao));
    // print(jsonEncode(jsonconclusao.dados));
    // print(jsonEncode(jsonconclusao.assinaturaTecnico));
    // print(jsonEncode(jsonconclusao.presencial));
    // print(jsonEncode(jsonconclusao.notificacaoResponsavel));
    // print(jsonEncode(jsonconclusao.confirmacaoPresencial));
    // print(jsonEncode(jsonconclusao.documentosResponsavel));
    // print(jsonEncode(jsonconclusao.assinaturaResponsavel));
    var jcon = jsonEncode(jsonconclusao);
    print(jcon);

    opcs.setString("${osid}@OSaFinalizardata", jcon);
    print(jcon);
    syncoff().enviar(osid);
  }

  enviar(osid) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();

    var empresaid = opcs.getInt('sessionid');
    var token = opcs.getString("${empresaid}@token");

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final data = await opcs.getString("${osid}@OSaFinalizardata");
    print(data);
    final url = Uri.parse(
        '${Urlconst().url}ordem_servico/sincronizacaoordemservico/$osid');

    final res = await http.post(url, headers: headers, body: data);
    final status = res.statusCode;
    if (status != 200) {
      print(res.reasonPhrase);
      print(res.request);
      print(res.headers);
      print(res.body);
      List<String>? ids = opcs.getStringList("osIDaFinalizar");
      if (ids == null) {
        ids = [];
        ids.add("$osid");
      }
      opcs.setStringList("osIDaFinalizar", ids);
      print(res.reasonPhrase);
      print(res.request);
      print(res.headers);
      print(res.body);
      throw Exception('http.post error: statusCode= $status');
    } else {
      print(res.reasonPhrase);
      print(res.request);
      print(res.headers);
      print(res.body);
      opcs.remove("${osid}@OSaFinalizardata");
      List<String>? ids = opcs.getStringList("osIDaFinalizar");
      ids?.remove(osid);
      opcs.setStringList("osIDaFinalizar", ids!);
    }
  }
}
