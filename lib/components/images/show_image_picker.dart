import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tracking_app_v1/utils/permission_helper.dart';

Future<List<XFile>> showImagePicker({int limit = 1}) async {
  PermissionStatus status = await PermissionHelper.cameraPermissionStatus();
  final List<XFile> images = [];

  if (status.isGranted) {
    final ImagePicker picker = ImagePicker();
    if (limit > 1) {
      images.addAll(await picker.pickMultiImage(limit: limit));
    } else {
      final img = await picker.pickImage(source: ImageSource.gallery);
      if (img != null) images.add(img);
    }
  }
  return images;
}
