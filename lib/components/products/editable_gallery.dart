import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tracking_app_v1/components/images/show_image_picker.dart';
import 'package:tracking_app_v1/constants/api_endpoints.dart';
import 'package:tracking_app_v1/models/image_source.dart';
import 'package:tracking_app_v1/pages/common/image_selector_page.dart';

class EditableGallery extends StatefulWidget {
  final String ownerId;
  final List<String> initImages;
  final void Function(ImageSource) onAddFile;
  final void Function(ImageSource) onRemoveFile;
  final void Function() onClearAll;
  final bool modifiable;

  const EditableGallery(
      {super.key,
      required this.initImages,
      required this.onAddFile,
      required this.onRemoveFile,
      required this.onClearAll,
      required this.ownerId,
      this.modifiable = true});

  @override
  State<EditableGallery> createState() => _EditableGalleryState();
}

//https://stackoverflow.com/questions/29588124/how-to-add-an-image-to-the-emulator-gallery-in-android-studio
class _EditableGalleryState extends State<EditableGallery> {
  final int galleryLimit = 3;
  List<ImageSource> _galleries = [];
  bool _isInit = true;

  @override
  void initState() {
    // fetchChangeGallery();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant EditableGallery oldWidget) {
    fetchChangeGallery();
    super.didUpdateWidget(oldWidget);
  }

  void fetchChangeGallery() {
    if (_isInit && widget.initImages.length > 1) {
      // print("Gallery: On fetching....");
      List<ImageSource> galleryFileItems =
          widget.initImages.getRange(1, widget.initImages.length).map((str) {
        var path = ApiEndpoints.getImagePath(str);
        return ImageSource(path: path, type: ImageType.network);
      }).toList();
      // print("Added ${widget.initImages.length} images");
      _galleries.addAll(galleryFileItems);
      _isInit = false;
    }
  }

  List<Widget> _buildListImage(BuildContext context) {
    final globalSize = MediaQuery.of(context).size;
    return _galleries.take(5).map((image) {
      return Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.all(3),
        width: 100,
        height: 100,
        child: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.5),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[400],
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: image.toImageWidget().image))),
            if (widget.modifiable)
              Positioned(
                  right: -3,
                  top: -5,
                  child: GestureDetector(
                    onTap: () {
                      print("Delete ${image.path}");
                      _galleries.remove(image);
                      widget.onRemoveFile(image);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade100,
                          border: Border.all(color: Colors.black)),
                      // width: 10,
                      // height: 10,
                      child: const Icon(
                        Icons.close,
                        size: 20,
                      ),
                    ),
                  ))
          ],
        ),
      );
    }).toList();
  }

  Widget _buildAddFrame() {
    var globalSize = MediaQuery.of(context).size;
    return InkWell(
      onTap: () async {
        // print("adding image...");
        // var rs = await Navigator.push<List<AssetEntity>>(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const ImageSelectorPage(
        //         maxSelected: 3,
        //       ),
        //     ));

        final rs = await showImagePicker(limit: 3);
        print("Got ${rs.length} item(s)");

        if (rs.isNotEmpty) {
          final files = rs.map((x) {
            return ImageSource(path: x.path, type: ImageType.file);
          }).toList();

          if (_galleries.length + rs.length >= galleryLimit) {
            _galleries.clear();
          }
          for (var file in files) {
            _galleries.add(file);
            widget.onAddFile(file);
          }
          setState(() {});
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        width: globalSize.width / 4,
        height: globalSize.width / 4,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black),
            gradient: RadialGradient(
                // radius:.5,
                colors: [
                  Colors.grey[100]!,
                  Colors.grey[300]!,
                  Colors.grey[400]!
                ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _galleries.length >= galleryLimit
                  ? Icons.change_circle
                  : Icons.add,
              color: Colors.grey[700],
            ),
            Text(
              _galleries.length >= galleryLimit ? "Switch" : "Add more",
              style: TextStyle(color: Colors.grey[700]),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var globaleSize = MediaQuery.of(context).size;
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      decoration: const BoxDecoration(
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.black))),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  width: globaleSize.width,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ..._buildListImage(context),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      if (widget.modifiable) _buildAddFrame(),
                      if (!widget.modifiable && _galleries.isEmpty)
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Empty gallery",
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
