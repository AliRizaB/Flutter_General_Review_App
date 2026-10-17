import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/alert_dialog_base.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for reviewies
// If toUpdateReview is given it will get the values from the review
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showReviewDialog(
  BuildContext context, {
  MediaReview? toUpdateReview,
}) async {
  final controller = Get.find<ReviewController>();
  final bool isEditing = (toUpdateReview != null);
  controller.initReviewForm(toUpdateReview);

  await Get.dialog(
    AlertDialogBase(
      isEditing: isEditing,
      label: 'Review',
      onSubmit: () async {
        if (isEditing) {
          await controller.updateReview();
        } else {
          await controller.addReview();
        }
      },
      children: [
        // Review Content
        CustomTextField(
          labelText: 'Review',
          onChanged: (value) => controller.content.value = value,
          initialValue: controller.content.value,
          maxLines: 5,
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
