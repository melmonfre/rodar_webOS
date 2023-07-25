import 'package:shared_preferences/shared_preferences.dart';

class salvarfotos{
  save(String id) async {
    SharedPreferences opcs = await SharedPreferences.getInstance();
    String? base64 = opcs.getString("base64camera");
    opcs.setString(id, base64!);
}
}