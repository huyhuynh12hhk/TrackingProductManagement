import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<PermissionStatus> storagePermissionStatus() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;

    if (!storagePermissionStatus.isGranted) {
      await Permission.storage.request();
    }

    storagePermissionStatus = await Permission.storage.status;

    return storagePermissionStatus;
  }

  static Future<PermissionStatus> cameraPermissionStatus() async {
    PermissionStatus storagePermissionStatus = await Permission.camera.status;

    if (!storagePermissionStatus.isGranted) {
      await Permission.camera.request();
    }

    storagePermissionStatus = await Permission.camera.status;

    return storagePermissionStatus;
  }
}
