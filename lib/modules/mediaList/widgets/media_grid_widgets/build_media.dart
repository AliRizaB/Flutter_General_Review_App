import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/load_image.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

DottedBorder buildMedia(Color statusColor, AppMedia currentMedia) {
  return DottedBorder(
    options: RectDottedBorderOptions(
      dashPattern: const [20, 25],
      stackFit: StackFit.passthrough,
      strokeWidth: 3,
      padding: const EdgeInsets.all(2),
      color: statusColor,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Stack(
        children: [
          // Media Image Render
          Positioned.fill(
            child: loadImage(currentMedia.imagePath, BoxFit.cover),
          ),

          // Title of the media is showing
          _buildMediaTitle(currentMedia),
        ],
      ),
    ),
  );
}

Positioned _buildMediaTitle(AppMedia currentMedia) {
  return Positioned(
    bottom: 0,
    left: 0,
    right: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black.withValues(alpha: 0.5), Colors.black],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      ),
      child: Text(
        currentMedia.name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'Isometra',
        ),
      ),
    ),
  );
}
