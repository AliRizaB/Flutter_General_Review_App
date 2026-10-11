// Essentials
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

// App Controllers and Models
import 'package:flutter_general_reviewer/Utilities/status_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';

// Customization
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';

Future showMediaDialog(BuildContext context, {AppMedia? toUpdateMedia}) async {
  final formKey = GlobalKey<FormState>();

  final bool isEditing = (toUpdateMedia != null);
  final mediaController = Get.find<MediaListController>();
  final statusController = Get.find<StatusController>();

  mediaController.initMediaForm(toUpdateMedia);

  if (statusController.statuses.isEmpty) {
    return Center(
      child: const Text(
        'No statuses available',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
  await Get.dialog(
    AlertDialog(
      title: Text(
        isEditing
            ? 'Update The ${mediaController.categoryName}'
            : 'Add ${mediaController.categoryName}',
      ),

      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Media Name
              _mediaTitle(mediaController),

              const SizedBox(height: 16),

              // Media Description
              _mediaDescription(mediaController),

              const SizedBox(height: 16),

              // Rating Bar
              _ratingWidget(mediaController),

              const SizedBox(height: 16),

              _statusSelectorDropdown(mediaController, statusController),

              const SizedBox(height: 16),

              _imageSelector(mediaController),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),

        Obx(
          () => ElevatedButton(
            onPressed: mediaController.isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      // Unfocus keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      // Dismiss dialog explicitly
                      // Can not use Get.Back() cause it is cauisng problem with the Success Snackbar
                      Navigator.of(context).pop();

                      if (isEditing) {
                        await mediaController.updateMedia();
                      } else {
                        await mediaController.addMedia();
                      }
                    }
                  },
            child: mediaController.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isEditing ? 'Update' : 'Add'),
          ),
        ),
      ],
    ),
  );
}

Obx _imageSelector(MediaListController mediaController) {
  return Obx(() {
    final hasImage = mediaController.imagePath.value.isNotEmpty;

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
                    child: Image.file(
                      File(mediaController.imagePath.value),
                      fit: BoxFit.cover,
                    ),
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

void showImagePickerOptions(MediaListController controller) {
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

Widget _statusSelectorDropdown(
  MediaListController mediaController,
  StatusController statusController,
) {
  return Obx(() {
    final int? selectedValue = mediaController.statusId.value == -1
        ? null
        : mediaController.statusId.value;

    return DropdownButtonFormField<int>(
      initialValue: selectedValue,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      hint: const Text('Select Status'),
      items: statusController.statuses
          .map(
            (e) => DropdownMenuItem(
              value: e.id!,
              child: Text(e.name, style: TextStyle(color: e.getColor)),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) {
          mediaController.statusId.value = value;
        }
      },
      validator: (value) {
        if (value == null || value == -1) {
          return 'Please select status';
        }
        return null;
      },
    );
  });
}

Obx _ratingWidget(MediaListController controller) {
  return Obx(
    () => RatingBar.builder(
      initialRating: controller.rating.value.toDouble(),
      itemCount: 6,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            );
          case 1:
            return const Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            );
          case 2:
            return const Icon(Icons.sentiment_neutral, color: Colors.amber);
          case 3:
            return const Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            );
          case 4:
            return const Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.green,
            );
          case 5:
            return const Icon(Icons.star, color: Colors.blue);
          default:
            return const Icon(Icons.error);
        }
      },
      onRatingUpdate: (value) => controller.rating.value = value.toInt(),
    ),
  );
}

TextFormField _mediaDescription(MediaListController controller) {
  return TextFormField(
    initialValue: controller.description.value,
    onChanged: (value) => controller.description.value = value,
    maxLines: 3,
    maxLength: 250,
    decoration: const InputDecoration(
      labelText: 'Description:',
      hintText: 'Maximum Length: 250',
      border: OutlineInputBorder(),
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please Enter A Small Description";
      }
      return null;
    },
  );
}

TextFormField _mediaTitle(MediaListController controller) {
  return TextFormField(
    initialValue: controller.name.value,
    decoration: InputDecoration(
      labelText: 'Media Name',
      border: const OutlineInputBorder(),
    ),
    onChanged: (value) => controller.name.value = value,
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return "Please Enter A Media Name";
      }
      return null;
    },
  );
}
