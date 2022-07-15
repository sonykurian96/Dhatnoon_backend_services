// import 'dart:html';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:agora_uikit/controllers/session_controller.dart';
import 'package:flutter/material.dart';

import 'package:visibility_detector/visibility_detector.dart';

class AgoraVideoCall extends StatefulWidget {
  const AgoraVideoCall({Key? key}) : super(key: key);

  @override
  State<AgoraVideoCall> createState() => _AgoraVideoCallState();
}

class _AgoraVideoCallState extends State<AgoraVideoCall> {
  bool isaudioStreaming = true;
  bool backCameraStreaming = true;

  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
        appId: "63a29f76b5704dd0bf01316fc9f8f736",
        channelName: "test",
        tempToken:
            "00663a29f76b5704dd0bf01316fc9f8f736IADyEvHr+9Kb4L/Gqe6iL9Dz5CBQzi03Lh5ixCz7whPjlAx+f9gAAAAAEACZ/16C5ifJYgEAAQDkJ8li"
        // username: "user",
        ),
  );

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuildig the stuff");
    print("rebuildig the stuff");
    print("rebuildig the stuff");

    Future.delayed(Duration(seconds: 2), () {
      switchCameraNew(sessionController: client.sessionController);
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Front camera streaming',
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
              AgoraVideoButtons(
                  client: client,
                  autoHideButtons: false,
                  enabledButtons: [
                    BuiltInButtons.callEnd
                  ],
                  extraButtons: [
                    ElevatedButton(
                      onPressed: () {
                        switchCameraNew(
                            sessionController: client.sessionController);
                      },
                      child: const Text('switch'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        toggleCameraNew(
                            sessionController: client.sessionController);
                      },
                      child: const Text('camera'),
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> switchCameraNew(
      {required SessionController sessionController}) async {
    await sessionController.value.engine?.switchCamera();
  }

  Future<void> toggleCameraNew(
      {required SessionController sessionController}) async {
    var status = await Permission.camera.status;
    if (sessionController.value.isLocalVideoDisabled && status.isDenied) {
      await Permission.camera.request();
    }
    sessionController.value = sessionController.value.copyWith(
        isLocalVideoDisabled: !(sessionController.value.isLocalVideoDisabled));
    await sessionController.value.engine
        ?.muteLocalVideoStream(sessionController.value.isLocalVideoDisabled);
  }
}
