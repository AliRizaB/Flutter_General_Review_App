import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';

ElevatedButton buildConfirmationButton(
  ThemeData theme,
  ReviewController controller,
  GlobalKey<FormState> formKey,
  BuildContext context,
  bool isEditing,
) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      side: BorderSide(
        color: theme.colorScheme.primary,
        width: 2, // Border width
      ),
    ),
    onPressed: () async {
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
    child: Text(isEditing ? 'Update' : 'Add'),
  );
}
