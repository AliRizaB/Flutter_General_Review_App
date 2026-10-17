import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/load_image.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectorField extends StatelessWidget {
  final MediaController mediaController;

  const ImageSelectorField({super.key, required this.mediaController});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final path = mediaController.imagePath.value;
      final hasImage = path.isNotEmpty && path != 'assets/images/noImage.jpg';

      return Column(
        children: [
          InkWell(
            onTap: () => mediaController.pickAndSaveImage(ImageSource.gallery),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: loadImage(
                        mediaController.imagePath.value,
                        BoxFit.cover,
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 40,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(height: 8),
                        Text('Tap to select from gallery'),
                      ],
                    ),
            ),
          ),
          if (hasImage)
            TextButton.icon(
              onPressed: () => mediaController.imagePath.value = '',
              icon: const Icon(Icons.delete, color: Colors.red),
              label: const Text(
                'Remove Photo',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      );
    });
  }
}
