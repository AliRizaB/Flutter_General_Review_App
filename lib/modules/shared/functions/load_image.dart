import 'dart:io';

import 'package:flutter/material.dart';

Widget loadImage(String? imagePath, BoxFit fit) {
  final String path = imagePath ?? '';
  final hasImage = path.isNotEmpty && path != 'assets/images/noImage.jpg';
  final isNetwork = path.startsWith('http://') || path.startsWith('https://');

  if (!hasImage) {
    return Image.asset('assets/images/noImage.jpg', fit: fit);
  }

  if (isNetwork) {
    return Image.network(
      path,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          const Center(child: Icon(Icons.broken_image, size: 24)),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  return Image.file(
    File(path),
    fit: fit,
    errorBuilder: (context, error, stackTrace) =>
        Image.asset('assets/images/noImage.jpg', fit: fit),
  );
}
