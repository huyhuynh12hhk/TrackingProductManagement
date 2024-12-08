import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:media_scanner/media_scanner.dart';

class TakePhotoView extends StatefulWidget {
  final List<CameraDescription> cameras;
  const TakePhotoView({super.key, required this.cameras});

  @override
  State<TakePhotoView> createState() => _TakePhotoViewState();
}

class _TakePhotoViewState extends State<TakePhotoView> {
  late CameraController cameraController;
  late Future<void> cameraValue;
  List<File> imagesList = [];
  bool isFlashOn = false;
  bool isRearCamera = true;

  @override
  void initState() {
    startCamera(0);
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void startCamera(int camera) {
    cameraController = CameraController(
      widget.cameras[camera],
      ResolutionPreset.high,
      enableAudio: false,
    );
    cameraValue = cameraController.initialize();
  }

  Future<File> saveImage(XFile image) async {
    final downlaodPath = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File('$downlaodPath/$fileName');

    try {
      await file.writeAsBytes(await image.readAsBytes());
    } catch (_) {}

    return file;
  }

  void takePicture() async {
    print("Start to take new picture");
    XFile? image;

    if (cameraController.value.isTakingPicture ||
        !cameraController.value.isInitialized) {
      return;
    }

    if (isFlashOn == false) {
      await cameraController.setFlashMode(FlashMode.off);
    } else {
      await cameraController.setFlashMode(FlashMode.torch);
    }
    image = await cameraController.takePicture();

    if (cameraController.value.flashMode == FlashMode.torch) {
      setState(() {
        cameraController.setFlashMode(FlashMode.off);
      });
    }

    final file = await saveImage(image);
    setState(() {
      imagesList.add(file);
    });
    MediaScanner.loadMedia(path: file.path);
  }

  Widget _buildPreviewImageSection(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Your image here",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            margin: EdgeInsets.all(5),
            width: globalSize.width > globalSize.height
                ? globalSize.height
                : globalSize.width,
            height: globalSize.width > globalSize.height
                ? globalSize.height
                : globalSize.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black),
              image: DecorationImage(
                  image: FileImage(imagesList.first), fit: BoxFit.fill),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.blue),
                      onPressed: () {
                        imagesList.clear();
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.restart_alt), Text("Again")],
                      )),
                ),
                SizedBox(
                  width: globalSize.width / 20,
                ),
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.green),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.check), Text("Confirm")],
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Take new picture"),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.camera_alt)
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          imagesList.length > 0
              ? _buildPreviewImageSection(context)
              : Container(
                  width: globalSize.width,
                  height: globalSize.height / 5 * 4,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal.shade200, width: 3),
                  ),
                  child: Stack(
                    children: [
                      //camera view
                      Align(
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: cameraValue,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return Stack(
                                children: [
                                  SizedBox(
                                    width: globalSize.width,
                                    height: globalSize.height / 5 * 4,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: SizedBox(
                                        width: globalSize.width,
                                        child: CameraPreview(cameraController),
                                      ),
                                    ),
                                  ),
                                  //flash and switch cam button
                                  // SafeArea(
                                  //   child: Align(
                                  //     alignment: Alignment.topRight,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(
                                  //           right: 5, top: 10),
                                  //       child: Column(
                                  //         mainAxisSize: MainAxisSize.min,
                                  //         children: [
                                  //           //flash
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               setState(() {
                                  //                 isFlashOn = !isFlashOn;
                                  //               });
                                  //             },
                                  //             child: Container(
                                  //               decoration: const BoxDecoration(
                                  //                 color: Color.fromARGB(
                                  //                     50, 0, 0, 0),
                                  //                 shape: BoxShape.circle,
                                  //               ),
                                  //               child: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(10),
                                  //                 child: isFlashOn
                                  //                     ? const Icon(
                                  //                         Icons.flash_on,
                                  //                         color: Colors.white,
                                  //                         size: 30,
                                  //                       )
                                  //                     : const Icon(
                                  //                         Icons.flash_off,
                                  //                         color: Colors.white,
                                  //                         size: 30,
                                  //                       ),
                                  //               ),
                                  //             ),
                                  //           ),
                                  //           const SizedBox(
                                  //             height: 20,
                                  //           ),
                                  //           //switch
                                  //           GestureDetector(
                                  //             onTap: () {
                                  //               setState(() {
                                  //                 isRearCamera = !isRearCamera;
                                  //               });
                                  //               isRearCamera
                                  //                   ? startCamera(0)
                                  //                   : startCamera(1);
                                  //             },
                                  //             child: Container(
                                  //               decoration: const BoxDecoration(
                                  //                 color: Color.fromARGB(
                                  //                     50, 0, 0, 0),
                                  //                 shape: BoxShape.circle,
                                  //               ),
                                  //               child: Padding(
                                  //                 padding:
                                  //                     const EdgeInsets.all(10),
                                  //                 child: isRearCamera
                                  //                     ? const Icon(
                                  //                         Icons.camera_rear,
                                  //                         color: Colors.white,
                                  //                         size: 30,
                                  //                       )
                                  //                     : const Icon(
                                  //                         Icons.camera_front,
                                  //                         color: Colors.white,
                                  //                         size: 30,
                                  //                       ),
                                  //               ),
                                  //             ),
                                  //           )
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),

                                  //shoot button
                                  SafeArea(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        // margin: EdgeInsets.only(top: globalSize.height/5*2-130),

                                        margin: EdgeInsets.only(bottom: 10),
                                        width: 70,
                                        height: 70,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(10)),
                                            onPressed: () {
                                              takePicture();
                                            },
                                            child:
                                                const Icon(Icons.camera_alt)),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
