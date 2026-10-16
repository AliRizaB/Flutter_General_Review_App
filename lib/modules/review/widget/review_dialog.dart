import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_dialog_widgets/build_content_field.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/form_submit_button.dart';
import 'package:get/get.dart';

// A dialog menu for both Update and Create usage for reviewies
// If toUpdateReview is given it will get the values from the review
// If not values will be empty.
// Context is needed for Navigation.pop cause Get.back() is having problem with the snackBars ( From BaseController for success and error )
Future<void> showReviewDialog(
  BuildContext context, {
  MediaReview? toUpdateReview,
}) async {
  final formKey = GlobalKey<FormState>();
  final controller = Get.find<ReviewController>();

  final bool isEditing = (toUpdateReview != null);

  final theme = Theme.of(context);

  controller.initReviewForm(toUpdateReview);

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
              buildContentField(controller),
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

        FormSubmitButton(
          formKey: formKey,
          isEditing: isEditing,
          onSubmit: () =>
              isEditing ? controller.updateReview() : controller.addReview(),
        ),
      ],
    ),
  );
}
