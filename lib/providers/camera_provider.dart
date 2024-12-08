import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraProvider extends ChangeNotifier {
  static late List<CameraDescription> _cameras;

  List<CameraDescription> get cameras => _cameras;

  static Future<void> initialization() async {
    _cameras = await availableCameras();
  }


}
