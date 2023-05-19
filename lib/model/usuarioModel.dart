class usuario{
  final int id;
  final String nome;
  final String logo;
  final String token;
  final String empresa;
  final int osid;
  const usuario({
    required this.id,
    required this.nome,
    required this.logo,
    required this.token,
    required this.empresa,
    required this.osid,
});

  Map<String, dynamic> tomap(){
    return{

    };

  }
}