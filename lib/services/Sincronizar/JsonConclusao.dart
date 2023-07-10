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

}

class Acessorios {
  int id;
  List<NotificacaoResponsavel> acessorios;
  String etapaApp;

  Acessorios({
    required this.id,
    required this.acessorios,
    required this.etapaApp,
  });

}

class NotificacaoResponsavel {
  NotificacaoResponsavel();
}

class Arquivos {
  List<Arquivo> arquivos;

  Arquivos({
    required this.arquivos,
  });

}

class Arquivo {
  String base64;
  String referencia;
  int remover;
  int indice;
  String etapa;

  Arquivo({
    required this.base64,
    required this.referencia,
    required this.remover,
    required this.indice,
    required this.etapa,
  });

}

class AssinaturaResponsavel {
  int id;
  String nome;
  String email;
  String telefone;
  String tipoEnvio;
  int idOs;
  String documento;
  String referencia;
  String assinatura;
  String observacaoCliente;
  String etapa;

  AssinaturaResponsavel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.tipoEnvio,
    required this.idOs,
    required this.documento,
    required this.referencia,
    required this.assinatura,
    required this.observacaoCliente,
    required this.etapa,
  });

}

class AssinaturaTecnico {
  String base64;
  String referencia;
  String nomeResponsavel;
  String observacaoCliente;
  String etapa;

  AssinaturaTecnico({
    required this.base64,
    required this.referencia,
    required this.nomeResponsavel,
    required this.observacaoCliente,
    required this.etapa,
  });

}

class Checkin {
  List<CheckinIten> itens;
  String localGps;
  String observacao;
  String etapa;

  Checkin({
    required this.itens,
    required this.localGps,
    required this.observacao,
    required this.etapa,
  });

}

class CheckinIten {
  int id;
  String descricao;
  int situacaoAntes;

  CheckinIten({
    required this.id,
    required this.descricao,
    required this.situacaoAntes,
  });

}

class Checkout {
  List<CheckoutIten> itens;
  String localGps;
  String etapa;

  Checkout({
    required this.itens,
    required this.localGps,
    required this.etapa,
  });

}

class CheckoutIten {
  int id;
  String descricao;
  int situacaoDepois;

  CheckoutIten({
    required this.id,
    required this.descricao,
    required this.situacaoDepois,
  });

}

class Dados {
  DateTime dataConclusaoOs;
  String observacaoOs;
  int hodometro;
  String etapa;

  Dados({
    required this.dataConclusaoOs,
    required this.observacaoOs,
    required this.hodometro,
    required this.etapa,
  });

}

class Deslocamento {
  int distanciaTec;
  int valorDeslocamentoTec;
  int pedagioTec;
  String motivoDiv;
  String etapa;

  Deslocamento({
    required this.distanciaTec,
    required this.valorDeslocamentoTec,
    required this.pedagioTec,
    required this.motivoDiv,
    required this.etapa,
  });

}

class DocumentosResponsavel {
  AssinaturaResponsavel documentoFrente;

  DocumentosResponsavel({
    required this.documentoFrente,
  });

}

class Equipamentos {
  int id;
  List<Equipamento> equipamentos;
  String etapaApp;

  Equipamentos({
    required this.id,
    required this.equipamentos,
    required this.etapaApp,
  });

}

class Equipamento {
  int id;
  String tipoTec;
  bool situacaoTec;
  EquipamentoTec equipamentoTec;

  Equipamento({
    required this.id,
    required this.tipoTec,
    required this.situacaoTec,
    required this.equipamentoTec,
  });

}

class EquipamentoTec {
  int id;
  String numero;
  String codigo;
  String documento;
  String status;
  bool cancelado;
  Tecnico tecnico;
  String localInstalacaoTec;

  EquipamentoTec({
    required this.id,
    required this.numero,
    required this.codigo,
    required this.documento,
    required this.status,
    required this.cancelado,
    required this.tecnico,
    required this.localInstalacaoTec,
  });

}

class Tecnico {
  int id;
  Pessoa pessoa;
  int valorHora;
  int kmAtendimento;
  bool funcionario;

  Tecnico({
    required this.id,
    required this.pessoa,
    required this.valorHora,
    required this.kmAtendimento,
    required this.funcionario,
  });

}

class Pessoa {
  int id;
  Empresa empresa;

  Pessoa({
    required this.id,
    required this.empresa,
  });

}

class Empresa {
  int id;
  String nome;
  String email;
  List<Telefone> telefones;
  Endereco endereco;
  String stringTelefone;
  String cnpj;

  Empresa({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefones,
    required this.endereco,
    required this.stringTelefone,
    required this.cnpj,
  });

}

class Endereco {
  int id;
  String rua;
  String numero;
  String bairro;
  String complemento;
  Cidade cidade;
  String cep;
  String coordenadas;

  Endereco({
    required this.id,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.complemento,
    required this.cidade,
    required this.cep,
    required this.coordenadas,
  });

}

class Cidade {
  int id;
  String nome;
  Estado estado;

  Cidade({
    required this.id,
    required this.nome,
    required this.estado,
  });

}

class Estado {
  int id;
  String sigla;
  String nome;

  Estado({
    required this.id,
    required this.sigla,
    required this.nome,
  });

}

class Telefone {
  int id;
  int tipo;
  String ddi;
  String ddd;
  String numero;
  String obs;
  String telefoneCompleto;

  Telefone({
    required this.id,
    required this.tipo,
    required this.ddi,
    required this.ddd,
    required this.numero,
    required this.obs,
    required this.telefoneCompleto,
  });

}

class MotivosManutencao {
  List<NotificacaoResponsavel> motivos;

  MotivosManutencao({
    required this.motivos,
  });

}
