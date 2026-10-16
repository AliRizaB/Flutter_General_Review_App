import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/load_image.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

Obx imageSelector(MediaController mediaController) {
  return Obx(() {
    final path = mediaController.imagePath.value;
    final hasImage = path.isNotEmpty && path != 'assets/images/noImage.jpg';
    Widget imageChild = loadImage(
      mediaController.imagePath.value,
      BoxFit.cover,
    );

    return Column(
      children: [
        InkWell(
          onTap: () => showImagePickerOptions(mediaController),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageChild,
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to add photo'),
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

void showImagePickerOptions(MediaController controller) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Get.back(); // Close bottom sheet
                await controller.pickAndSaveImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                Get.back(); // Close bottom sheet
                await controller.pickAndSaveImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
