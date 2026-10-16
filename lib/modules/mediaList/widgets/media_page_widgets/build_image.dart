  import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/load_image.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

Widget buildMediaBanner(ThemeData theme, AppMedia media) {
    return SizedBox(
      height: 280,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRect(
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: loadImage(media.imagePath, BoxFit.cover),
              ),
            ),
          ),

          Positioned.fill(child: Container(color: Colors.black.withAlpha(102))),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(120),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
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