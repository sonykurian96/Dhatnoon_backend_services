import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:raw_testing/agora_video_call.dart';

import 'intermediate.dart';

List<CameraDescription> cameras = [];
int count = 0;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  runApp(GetMaterialApp(home: Test()));
}

class Test extends StatelessWidget {
  Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("that's it"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(Intermediate());
        },
      ),
    );
  }
}


