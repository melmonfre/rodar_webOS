class JsonConclusao {
  Checkin checkin;
  Equipamentos equipamentos;
  Acessorios acessorios;
  Arquivos arquivos;
  Deslocamento deslocamento;
  Checkout checkout;
  MotivosManutencao motivosManutencao;
  Dados dados;
  AssinaturaTecnico assinaturaTecnico;
  bool presencial;
  NotificacaoResponsavel notificacaoResponsavel;
  AssinaturaResponsavel confirmacaoPresencial;
  DocumentosResponsavel documentosResponsavel;
  AssinaturaResponsavel assinaturaResponsavel;

  JsonConclusao({
    required this.checkin,
    required this.equipamentos,
    required this.acessorios,
    required this.arquivos,
    required this.deslocamento,
    required this.checkout,
    required this.motivosManutencao,
    required this.dados,
    required this.assinaturaTecnico,
    required this.presencial,
    required this.notificacaoResponsavel,
    required this.confirmacaoPresencial,
    required this.documentosResponsavel,
    required this.assinaturaResponsavel,
  });

  // Map<String, dynamic> toJson() => {
  //   "acessorios": acessorios ,
  //   "arquivos ": arquivos,
  //   "confirmacaoAgendamento": confirmacaoAgendamento,
  //   "contatos": contatos,
  //   "dataEmissao": ,
  //   "dataInstalacao": ,
  //   "descricaoItens ": ,
  //   "descricaoMotivos ": ,
  //   "descricaoMotivosTecnico ": ,
  //   "descricaoServicos": ,
  //   "descricaoServicosString": ,
  //   "distanciaDeslocamento": deslocamento.,
  //   "distanciaDeslocamentoOriginal": ,
  //   "distanciaDeslocamentoTecnico": deslocamento.distanciaTec,
  //   "endereco": endereco,
  //   "enderecoOrigem": ,
  //   "equipamentos": equipamentos,
  //   "etapaAPP": ,
  //   "hodometro": hodo,
  //   "id": ,
  //   "motivos": ,
  //   "motivosTecnico": motivosManutencao,
  //   "observacao": ,
  //   "servicos": ,
  //   "tecnico": ,
  //   "valorDeslocamento": ,
  //   "valorDeslocamentoOriginal": ,
  //   "valorDeslocamentoTecnico": ,
  //   "valorPedagio": ,
  //   "valorPedagioOriginal": ,
  //   "valorPedagioTecnico": ,
  //   "veiculo": veiculo,
  //   "visitaFrustrada": visitaFrustrada,
  // };
}

class Acessorios {
  int? id;
  List<NotificacaoResponsavel>? acessorios;
  String? etapaApp;

  Acessorios({
    this.id,
    this.acessorios,
    this.etapaApp,
  });
}

class NotificacaoResponsavel {
  var notificacaoResponsavel;
}

class Arquivos {
  List<Arquivo>? arquivos;

  Arquivos({
    this.arquivos,
  });
}

class Arquivo {
  String? base64;
  String? referencia;
  int? remover;
  int? indice;
  String? etapa;

  Arquivo({
    this.base64,
    this.referencia,
    this.remover,
    this.indice,
    this.etapa,
  });
}

class AssinaturaResponsavel {
  int? id;
  String? nome;
  String? email;
  String? telefone;
  String? tipoEnvio;
  int? idOs;
  String? documento;
  String? referencia;
  String? assinatura;
  String? observacaoCliente;
  String? etapa;

  AssinaturaResponsavel({
    this.id,
    this.nome,
    this.email,
    this.telefone,
    this.tipoEnvio,
    this.idOs,
    this.documento,
    this.referencia,
    this.assinatura,
    this.observacaoCliente,
    this.etapa,
  });
}

class AssinaturaTecnico {
  String? base64;
  String? referencia;
  String? nomeResponsavel;
  String? observacaoCliente;
  String? etapa;

  AssinaturaTecnico({
    this.base64,
    this.referencia,
    this.nomeResponsavel,
    this.observacaoCliente,
    this.etapa,
  });
}

class Checkin {
  List<CheckinIten>? itens;
  String? localGps;
  String? observacao;
  String? etapa;

  Checkin({
    this.itens,
    this.localGps,
    this.observacao,
    this.etapa,
  });

  Map<String, dynamic> toJson() => {'localGps': localGps, 'itens': itens};
}

class CheckinIten {
  int? id;
  String? descricao;
  int? situacaoAntes;

  CheckinIten({
    this.id,
    this.descricao,
    this.situacaoAntes,
  });

  Map<String, dynamic> toJson() => {'id': id, 'descricao': descricao};
}

class Checkout {
  List<CheckoutIten>? itens;
  String? localGps;
  String? etapa;

  Checkout({
    this.itens,
    this.localGps,
    this.etapa,
  });
}

class CheckoutIten {
  int? id;
  String? descricao;
  int? situacaoDepois;

  CheckoutIten({
    this.id,
    this.descricao,
    this.situacaoDepois,
  });
}

class Dados {
  DateTime? dataConclusaoOs;
  String? observacaoOs;
  double? hodometro;
  String? etapa;

  Dados({
    this.dataConclusaoOs,
    this.observacaoOs,
    this.hodometro,
    this.etapa,
  });
}

class Deslocamento {
  double? distanciaTec;
  double? valorDeslocamentoTec;
  double? pedagioTec;
  String? motivoDiv;
  String? etapa;

  Deslocamento({
    this.distanciaTec,
    this.valorDeslocamentoTec,
    this.pedagioTec,
    this.motivoDiv,
    this.etapa,
  });
}

class DocumentosResponsavel {
  AssinaturaResponsavel? documentoFrente;

  DocumentosResponsavel({
    this.documentoFrente,
  });
}

class Equipamentos {
  int? id;
  List<Equipamento>? equipamentos;
  String? etapaApp;

  Equipamentos({
    this.id,
    this.equipamentos,
    this.etapaApp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'equipamentos': equipamentos,
        'etapaApp': etapaApp,
      };
}

class Equipamento {
  int? id;
  String? tipoTec;
  bool? situacaoTec;
  EquipamentoTec? equipamentoTec;

  Equipamento({
    this.id,
    this.tipoTec,
    this.situacaoTec,
    this.equipamentoTec,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
      };
}

class EquipamentoTec {
  int? id;
  String? numero;
  String? codigo;
  String? documento;
  String? status;
  bool? cancelado;
  Tecnico? tecnico;
  String? localInstalacaoTec;

  EquipamentoTec({
    this.id,
    this.numero,
    this.codigo,
    this.documento,
    this.status,
    this.cancelado,
    this.tecnico,
    this.localInstalacaoTec,
  });
}

class Tecnico {
  int? id;
  Pessoa? pessoa;
  double? valorHora;
  double? kmAtendimento;
  bool? funcionario;

  Tecnico({
    this.id,
    this.pessoa,
    this.valorHora,
    this.kmAtendimento,
    this.funcionario,
  });

  Tecnico.fromJson(json) {
    id = json['id'];
    pessoa?.fromJson(json['pessoa']);
    valorHora = json['valorHora'].toDouble();
    kmAtendimento = json['kmAtendimento'].toDouble();
    funcionario = json['funcionario'];
  }
}

class Pessoa {
  int? id;
  Empresa? empresa;

  Pessoa({
    this.id,
    this.empresa,
  });

  fromJson(json) {
    id = json['id'];
    empresa?.fromJson(json['empresa']);
  }
}

class Empresa {
  int? id;
  String? nome;
  String? email;
  List<Telefone>? telefones;
  Endereco? endereco;
  String? stringTelefone;
  String? cnpj;

  Empresa({
    this.id,
    this.nome,
    this.email,
    this.telefones,
    this.endereco,
    this.stringTelefone,
    this.cnpj,
  });

  fromJson(json) {
    id = json['id'];
    nome = json['nome'];
    email = json['email'];
    if (json['telefones'] != null) {
      telefones = json['telefones'];
    }
    endereco?.fromJson(json['endereco']);
    stringTelefone = json['stringTelefone'];
    cnpj = json['cnpj'];
  }
}

class Endereco {
  int? id;
  String? rua;
  String? numero;
  String? bairro;
  String? complemento;
  Cidade? cidade;
  String? cep;
  String? coordenadas;

  Endereco({
    this.id,
    this.rua,
    this.numero,
    this.bairro,
    this.complemento,
    this.cidade,
    this.cep,
    this.coordenadas,
  });

  fromJson(json) {
    id = json['id'];
    rua = json['rua'];
    numero = json['numero'];
    bairro = json['bairro'];
    complemento = json['complemento'];
    cidade?.fromJson(json['cidade']);
    cep = json['cep'];
    coordenadas = json['coordenadas'];
  }
}

class Cidade {
  int? id;
  String? nome;
  Estado? estado;

  Cidade({
    this.id,
    this.nome,
    this.estado,
  });

  fromJson(json) {
    id = json['id'];
    nome = json['nome'];
    estado?.fromJson(json['estado']);
  }
}

class Estado {
  int? id;
  String? sigla;
  String? nome;

  Estado({
    this.id,
    this.sigla,
    this.nome,
  });

  fromJson(json) {
    id = json['id'];
    sigla = json['sigla'];
    nome = json['nome'];
  }
}

class Telefone {
  int? id;
  int? tipo;
  String? ddi;
  String? ddd;
  String? numero;
  String? obs;
  String? telefoneCompleto;

  Telefone({
    this.id,
    this.tipo,
    this.ddi,
    this.ddd,
    this.numero,
    this.obs,
    this.telefoneCompleto,
  });
}

class MotivosManutencao {
  List? motivos;

  MotivosManutencao({
    this.motivos,
  });
}
