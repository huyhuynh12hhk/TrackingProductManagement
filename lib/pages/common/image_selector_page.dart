import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracking_app_v1/components/images/select_device_image_view.dart';
import 'package:tracking_app_v1/components/images/take_photo_view.dart';
import 'package:tracking_app_v1/providers/camera_provider.dart';


// https://stackoverflow.com/questions/68080493/how-to-convert-cameracontrollers-xfile-to-image-type-in-flutter
class ImageSelectorPage extends StatefulWidget {
  final int maxSelected;
  const ImageSelectorPage({super.key, this.maxSelected = 1});

  @override
  State<ImageSelectorPage> createState() => _ImageSelectorPageState();
}

class _ImageSelectorPageState extends State<ImageSelectorPage>{



  @override
  Widget build(BuildContext context) {
    final cameras = Provider.of<CameraProvider>(context).cameras;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: const Text("Select your image"),
        ),
        body: SelectDeviceImageView(
            maxSelected: widget.maxSelected,
          ),
        );
  }
}
