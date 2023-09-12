import 'dart:convert';

class JsonConclusao {
  Checkin checkin;
  Equipamentos equipamentos;
  Acessorios? acessorios;
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

  Map<String, dynamic> toJson() => {
        'checkin': checkin,
        'equipamentos': equipamentos,
        'acessorios': acessorios ?? [],
        'arquivos': arquivos,
        'deslocamento': deslocamento,
        'checkout': checkout,
        'motivosManutencao': motivosManutencao,
        'dados': dados,
        'assinaturaTecnico': assinaturaTecnico,
        'presencial': presencial,
        'notificacaoResponsavel': notificacaoResponsavel,
        'confirmacaoPresencial': confirmacaoPresencial,
        'documentosResponsavel': documentosResponsavel,
        'assinaturaResponsavel': assinaturaResponsavel
      };
}


class Acessorios {
  String encodedStr;
  int osid;

  Acessorios({
    required this.osid,
    required this.encodedStr,
  });
  Map<String, dynamic> toJson() => ({
    "id": osid,
    "acessorios": jsonDecode(encodedStr),
    "etapaAPP": "ACESSORIOS",
  });
}

class NotificacaoResponsavel {
  var notificacaoResponsavel;
  Map<String, dynamic> toJson() =>
      {'notificacaoResponsavel': notificacaoResponsavel};
}

class Arquivos {
  List<Arquivo>? arquivos;

  Arquivos({
    this.arquivos,
  });
  Map<String, dynamic> toJson() => {'arquivos': arquivos};
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
  Map<String, dynamic> toJson() => {
        'base64': base64,
        'referencia': referencia,
        'remover': remover,
        'indice': indice,
        'etapa': etapa,
      };
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'telefone': telefone,
        'tipoEnvio': tipoEnvio,
        'idOs': idOs,
        'documento': documento,
        'referencia': referencia,
        'assinatura': assinatura,
        'observacaoCliente': observacaoCliente,
        'etapa': etapa,
      };
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
  Map<String, dynamic> toJson() => {
        'base64': base64,
        'referencia': referencia,
        'nomeResponsavel': nomeResponsavel,
        'observacaoCliente': observacaoCliente,
        'etapa': etapa
      };
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

  Map<String, dynamic> toJson() => {
        'itens': itens,
        'localGps': localGps,
        'observacao': observacao,
        'etapa': etapa,
      };
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

  Map<String, dynamic> toJson() =>
      {'id': id, 'descricao': descricao, 'situacaoAntes': situacaoAntes};
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
  Map<String, dynamic> toJson() =>
      {'itens': itens, 'localGps': localGps, 'etapa': etapa};
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
  Map<String, dynamic> toJson() =>
      {'id': id, 'descricao': descricao, 'situacaoDepois': situacaoDepois};
}

class Dados {
  dynamic dataConclusaoOs;
  String? observacaoOs;
  double? hodometro;
  String? etapa;

  Dados({
    this.dataConclusaoOs,
    this.observacaoOs,
    this.hodometro,
    this.etapa,
  });
  Map<String, dynamic> toJson() => {
        'dataConclusaoOs': dataConclusaoOs,
        'observacaoOs': observacaoOs,
        'hodometro': hodometro,
        'etapa': etapa,
      };
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
  Map<String, dynamic> toJson() => {
        'distanciaTec': distanciaTec,
        'valorDeslocamentoTec': valorDeslocamentoTec,
        'pedagioTec': pedagioTec,
        'motivoDiv': motivoDiv,
        'etapa': etapa,
      };
}

class DocumentosResponsavel {
  AssinaturaResponsavel? documentoFrente;

  DocumentosResponsavel({
    this.documentoFrente,
  });
  Map<String, dynamic> toJson() => {'documentoFrente': documentoFrente};
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
  String? tipo;
  String? tipoTec;
  EquipamentoTec? equipamento;
  EquipamentoTec? equipamentoTec;
  EquipamentoTec? equipamentoRetirado;
  EquipamentoTec? equipamentoRetiradoTec;
  String? localInstalacao;
  String? localInstalacaoTec;

  Equipamento(
      {this.id,
      this.tipo,
      this.tipoTec,
      this.equipamento,
      this.equipamentoTec,
      this.equipamentoRetirado,
      this.equipamentoRetiradoTec,
      this.localInstalacao,
      this.localInstalacaoTec});

  Equipamento.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        tipo = json['tipo'],
        tipoTec = json['tipoTec'],
        equipamento = json.containsKey('equipamento')
            ? EquipamentoTec.fromJson(json['equipamento'])
            : null,
        equipamentoTec = json.containsKey('equipamentoTec')
            ? EquipamentoTec.fromJson(json['equipamentoTec'])
            : null,
        equipamentoRetirado = json.containsKey('equipamentoRetirado')
            ? EquipamentoTec.fromJson(json['equipamentoRetirado'])
            : null,
        equipamentoRetiradoTec = json.containsKey('equipamentoRetiradoTec')
            ? EquipamentoTec.fromJson(json['equipamentoRetiradoTec'])
            : null,
        localInstalacao = json['localInstalacao'],
        localInstalacaoTec = json['localInstalacaoTec'];

  // fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   tipo = json['tipo'];
  //   tipoTec = json['tipoTec'];
  //   equipamento = json['equipamento'];
  //   equipamentoTec = json['equipamentoTec'];
  //   equipamentoRetirado = json['equipamentoRetirado'];
  //   equipamentoRetiradoTec = json['equipamentoRetiradoTec'];
  //   localInstalacao = json['localInstalacao'];
  //   localIntalacaoTec = json['localIntalacaoTec'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tipo'] = this.tipo;
    data['tipoTec'] = this.tipoTec;
    data['equipamento'] = this.equipamento;
    data['equipamentoTec'] = this.equipamentoTec;
    data['equipamentoRetirado'] = this.equipamentoRetirado;
    data['equipamentoRetiradoTec'] = this.equipamentoRetiradoTec;
    data['localInstalacao'] = this.localInstalacao;
    data['localInstalacaoTec'] = this.localInstalacaoTec;
    return data;
  }
}

class EquipamentoTec {
  int? id;
  String? codigo;

  EquipamentoTec({
    this.id,
    this.codigo,
  });

  EquipamentoTec.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        codigo = json['codigo'];
  Map<String, dynamic> toJson() => {'id': id, 'codigo': codigo};
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'pessoa': pessoa,
        'valorHora': valorHora,
        'kmAtendimento': kmAtendimento,
        'funcionario': funcionario,
      };
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
  Map<String, dynamic> toJson() => {'id': id, 'empresa': empresa};

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
  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'telefones': telefones,
        'endereco': endereco,
        'stringTelefone': stringTelefone,
        'cnpj': cnpj,
      };

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
  Map<String, dynamic> toJson() => {
        'id': id,
        'rua': rua,
        'numero': numero,
        'bairro': bairro,
        'complemento': complemento,
        'cidade': cidade,
        'cep': cep,
        'coordenadas': coordenadas
      };

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
  Map<String, dynamic> toJson() => {'id': id, 'nome': nome, 'estado': estado};

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
  Map<String, dynamic> toJson() => {'id': id, 'sigla': sigla, 'nome': nome};
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
  Map<String, dynamic> toJson() => {
        'id': id,
        'tipo': tipo,
        'ddi': ddi,
        'ddd': ddd,
        'numero': numero,
        'obs': obs,
        'telefoneCompleto': telefoneCompleto
      };
}

class MotivosManutencao {
  List<MotivoManutencao>? motivos;

  MotivosManutencao({
    this.motivos,
  });
  Map<String, dynamic> toJson() => {'motivos': motivos};
}

class MotivoManutencao {
  int? id;

  MotivoManutencao({this.id});

  Map<String, dynamic> toJson() => {'id': id};
}
