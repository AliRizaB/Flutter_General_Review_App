import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/medias/media_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

Future showAddMediaDialog(
  BuildContext context, {
  AppMedia? toUpdateMedia,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<MediaController>();
  final bool isEditing = (toUpdateMedia != null);

  await Get.dialog(
    AlertDialog(
      title: Text(
        isEditing
            ? 'Update ${controller.categoryName}'
            : 'Add New ${controller.categoryName}',
      ),

      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Media Name
              TextFormField(
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
              ),

              const SizedBox(height: 16),

              // Media Description
              TextFormField(
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
              ),

              const SizedBox(height: 16),

              // Rating Bar
              Obx(
                () => RatingBar.builder(
                  initialRating: controller.rating.value.toDouble(),
                  itemCount: 5,
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
                        return const Icon(
                          Icons.sentiment_neutral,
                          color: Colors.amber,
                        );
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
                      default:
                        return const Icon(Icons.error);
                    }
                  },
                  onRatingUpdate: (value) =>
                      controller.rating.value = value.toInt(),
                ),
              ),
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
            onPressed: controller.isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      // Unfocus keyboard
                      FocusManager.instance.primaryFocus?.unfocus();

                      // Dismiss dialog explicitly
                      // Can not use Get.Back() cause it is cauisng problem with the Success Snackbar
                      Navigator.of(context).pop();

                      if (isEditing) {
                        await controller.updateMedia();
                      } else {
                        await controller.addMedia();
                      }
                    }
                  },
            child: controller.isLoading
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
