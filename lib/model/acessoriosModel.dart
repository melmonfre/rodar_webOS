class acessorios{
  final int id;
  final String descricao;
  final int osid;

  const acessorios({
    required this.id,
    required this.descricao,
    required this.osid,
  });

  Map<String, dynamic> tomap(){
    return{
      'id':id,
      'descricao':descricao,
      'osid':osid,
    };

  }

}