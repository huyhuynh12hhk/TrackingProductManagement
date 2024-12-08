import 'dart:io';

import 'package:flutter/material.dart';

class ImageSource {
  final String path;
  final ImageType type;

  ImageSource({required this.path, required this.type});

  Image toImageWidget() {
    switch (type) {
      case ImageType.asset:
        return Image.asset(path, fit: BoxFit.cover);
      case ImageType.file:
        return Image.file(File(path), fit: BoxFit.cover);
      case ImageType.network:
        return Image.network(path, fit: BoxFit.cover);
      default:
        return Image.asset('assets/images/product.png'); // Fallback for unsupported types
    }
  }
}

enum ImageType { asset, file, network }
