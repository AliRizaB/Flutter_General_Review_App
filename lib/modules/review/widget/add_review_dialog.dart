import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for reviewies
// If toUpdateReview is given it will get the values from the review
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showAddReviewDialog(
  BuildContext context, {
  MediaReview? toUpdateStatus,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<ReviewController>();

  final bool isEditing = (toUpdateStatus != null);

  final theme = Theme.of(context);

  controller.initReviewForm(toUpdateStatus);

  await Get.dialog(
    AlertDialog(
      surfaceTintColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,

      title: Text(isEditing ? 'Update Review' : 'Add New Review'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              // Review Content
              TextFormField(
                initialValue: controller.content.value,
                onChanged: (value) => controller.content.value = value,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Review',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please Enter A Review";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),

        Obx(
          () => ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                color: Theme.of(Get.context!).colorScheme.primary,
                width: 2, // Border width
              ),
            ),
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
                        await controller.updateReview();
                      } else {
                        await controller.addReview();
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
