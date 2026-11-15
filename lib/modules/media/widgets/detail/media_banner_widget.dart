// Essentials
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/functions/load_image.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

final _blurFilter = ImageFilter.blur(sigmaX: 10, sigmaY: 10);
const _overlayColor = Color(0x66000000); // Colors.black.withAlpha(102)
const _bannerShadow = [
  BoxShadow(
    color: Color(0x78000000), // Colors.black.withAlpha(120)
    blurRadius: 12,
    spreadRadius: 2,
    offset: Offset(0, 4),
  ),
];

class MediaBannerWidget extends StatelessWidget {
  final AppMedia media;

  const MediaBannerWidget({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: _blurFilter,
                child: loadImage(media.imagePath, BoxFit.cover),
              ),
            ),
          ),

          Positioned.fill(child: Container(color: _overlayColor)),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _bannerShadow,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: loadImage(media.imagePath, BoxFit.contain),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
