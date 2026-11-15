import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/functions/load_image.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectorWidget extends GetView<MediaController> {
  const ImageSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final path = controller.imagePath.value;
      final hasImage = path.isNotEmpty && path != 'assets/images/noImage.jpg';

      return Column(
        children: [
          InkWell(
            onTap: _showImageSourceSheet,
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
                        controller.imagePath.value,
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
                        Text('Tap to select an Image'),
                      ],
                    ),
            ),
          ),
          if (hasImage)
            TextButton.icon(
              onPressed: () => controller.imagePath.value = '',
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

  Future<void> _showImageSourceSheet() {
    return Get.bottomSheet(
      backgroundColor: Get.theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Get.theme.colorScheme.primary),
      ),
      SafeArea(
        child: Padding(
          padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  Get.back();
                  controller.saveImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  Get.back();
                  controller.saveImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
