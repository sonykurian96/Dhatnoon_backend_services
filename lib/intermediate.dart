import 'package:http/http.dart';
import 'dart:convert';

class Generator{

  static Future<String> getCode() async {
    String link =
        "serverlink";

    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    return data["token"];
  }
}
