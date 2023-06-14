import 'package:shared_preferences/shared_preferences.dart';

class salvarfotos{
  save(String id) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    List<String>? base64 = opcs.getStringList("base64camera");
    opcs.setStringList(id, base64!);
}
}