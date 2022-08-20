import 'package:http/http.dart';
import 'dart:convert';

class Generator{

  static Future<String> getCode() async {
    String link =
        "https://agora-node-tokenserver-1.davidcaleb.repl.co/access_token?channelName=test";

    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    return data["token"];
  }
}
