import 'dart:io';

import 'package:flutter/material.dart';

Widget loadImage(String? imagePath, BoxFit fit) {
  final String path = imagePath ?? '';
  final hasImage = path.isNotEmpty && path != 'assets/images/noImage.jpg';
  final isNetwork = path.startsWith('http://') || path.startsWith('https://');

  Widget imageChild;

  if (!hasImage) {
    imageChild = Image.asset('assets/images/noImage.jpg', fit: fit);
  } else if (isNetwork) {
    imageChild = Image.network(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.broken_image, size: 30)),
      loadingBuilder: (context, widget, loadingProgress) {
        if (loadingProgress == null) return widget;
        return Center(child: CircularProgressIndicator());
      },
    );
  } else {
    imageChild = Image.file(
      File(path),
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Image.asset('assets/images/noImage.jpg', fit: fit),
    );
  }

  return imageChild;
}
