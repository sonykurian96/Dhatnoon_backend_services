import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart';
import 'dart:convert';

import 'main.dart';

class Intermediate extends StatefulWidget {
  @override
  State<Intermediate> createState() => _IntermediateState();
}

class _IntermediateState extends State<Intermediate> {
  String? token;

  @override
  void initState() {
    getCode();
    super.initState();
  }

  getCode() async {
    String link =
        "serverURL";
    Response response = await get(Uri.parse(link));
    Map data = jsonDecode(response.body);
    setState(() {
      token = data["token"];
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token != null)
      return AgoraVideoCall(token: token!);
    else
      return Center(child: CircularProgressIndicator());
  }
}

class AgoraVideoCall extends StatefulWidget {
  const AgoraVideoCall({Key? key, required this.token}) : super(key: key);

  final String token;

  @override
  State<AgoraVideoCall> createState() => _AgoraVideoCallState();
}

class _AgoraVideoCallState extends State<AgoraVideoCall> {
  late final AgoraClient client;

  @override
  void initState() {
    setClient();
    initAgora();
    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    super.dispose();
  }

  void setClient() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "appid",
          channelName: "test",
          tempToken: widget.token
          // username: "user",
          ),
    );
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {

    if(count == 0) {
      Future.delayed(Duration(seconds: 2), () {
        switchCamera(sessionController: client.sessionController);
      });
      count = count + 1;
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Rear camera streaming',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff270745),
                  Color(0xff250543),
                  Color(0xff170036),
                  Color(0xff120032),
                  Color(0xff120032),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
            ],
          ),
        ),
      ),
    );
  }
}
