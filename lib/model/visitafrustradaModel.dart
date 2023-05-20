class desloc{
  final int id;
  final String base64;
  final double deslocamento;
  final double pedagio;
  final String motivodiv;
  final String motivo;
  final String localgps;
  final String etapa;
  final int osid;
  const desloc({
    required this.id,
    required this.base64,
    required this.deslocamento,
    required this.pedagio,
    required this.motivodiv,
    required this.motivo,
    required this.localgps,
    required this.etapa,
    required this.osid,
  });

  Map<String, dynamic> tomap(){
    return{

    };

  }
}