class arquivos{
  final int id;
  final String base64;
  final String etapa;
  final int osid;
  const arquivos({
    required this.id,
    required this.base64,
    required this.etapa,
    required this.osid,
  });

  Map<String, dynamic> tomap(){
    return{
      'id':id,
      'base64':base64,
      'etapa':etapa,
      'osid':osid
    };

  }
}