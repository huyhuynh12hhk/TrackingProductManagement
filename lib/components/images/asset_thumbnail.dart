import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetThumbnail extends StatefulWidget {
  final AssetEntity asset;
  final File file;
  final bool isSelected;
  final void Function() onSelected;
  final void Function() onUnselected;
  const AssetThumbnail(
      {super.key,
      required this.asset,
      required this.onSelected,
      required this.onUnselected,
      required this.file,
      required this.isSelected});

  @override
  State<AssetThumbnail> createState() => _AssetThumbnailState();
}

class _AssetThumbnailState extends State<AssetThumbnail> {
  bool _isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        //  FutureBuilder<Uint8List>(
        //   future: widget.asset.thumbnailData.then((value) => value!),
        //   builder: (_, snapshot) {
        //     final bytes = snapshot.data;
        //     if (bytes == null) {
        //       return const Padding(
        //         padding: EdgeInsets.all(10.0),
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     return
        InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        // setState(() {
        //   _isSelected = !_isSelected;
        // });
        // if (_isSelected) {
        // widget.onSelected();
        // } else {
        widget.onSelected();
        // }
      },
      child: Stack(
        children: [
          // Wrap the image in a Positioned.fill to fill the space
          // Positioned.fill(child: Image.memory(bytes, fit: BoxFit.cover)),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: FileImage(widget.file), fit: BoxFit.cover)),
            // child: Positioned.fill(
            //     child: Image.file(widget.file, fit: BoxFit.cover)),
          ),

          // if (_isSelected)
          if (widget.isSelected)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            )
        ],
      ),
      //   );
      // },
    );
  }
}
