import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/load_image.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

const _titleGradient = LinearGradient(
  colors: [Colors.black, Colors.black54],
  begin: Alignment.bottomCenter,
  end: Alignment.topCenter,
);

class MediaCard extends StatelessWidget {
  final AppMedia media;
  final Color statusColor;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.media,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
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
              Positioned.fill(child: loadImage(media.imagePath, BoxFit.cover)),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(gradient: _titleGradient),
                  child: Text(
                    media.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Isometra',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
