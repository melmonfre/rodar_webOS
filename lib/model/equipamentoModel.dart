class equipamento{
  final int id;
  final String num;
  final String cod;
  final String doc;
  final String status;
  final int acessorios;
  final int osid;
  const equipamento({
    required this.id,
    required this.num,
    required this.cod,
    required this.doc,
    required this.status,
    required this.acessorios,
    required this.osid,
});

  Map<String, dynamic> tomap(){
    return{

    };

  }
}