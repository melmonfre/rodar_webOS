class checklist{
  final int id;
  final String desc;
  final int situantes;
  final int situdepois;
  final String obsantes;
  final String obsdepois;
  final int osid;
  const checklist({
    required this.id,
    required this.desc,
    required this.situantes,
    required this.situdepois,
    required this.obsantes,
    required this.obsdepois,
    required this.osid,
  });

  Map<String, dynamic> tomap(){
    return{
      'id':id,
      'desc':desc,
      'situantes':situantes,
      'situdepois':situdepois,
      

    };

  }
}