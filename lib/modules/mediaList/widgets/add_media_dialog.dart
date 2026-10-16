import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/api_options.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/description_field.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/image_selector.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/rating_widget.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/status_selector.dart';
import 'package:flutter_general_reviewer/modules/mediaList/widgets/add_media_widgets/title_field.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

// App Controllers and Models
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';

Future showMediaDialog(BuildContext context, {AppMedia? toUpdateMedia}) async {
  final formKey = GlobalKey<FormState>();

  final bool isEditing = (toUpdateMedia != null);
  final mediaController = Get.find<MediaController>();
  final statusController = Get.find<StatusController>();
  final storageService = Get.find<StorageService>();

  final theme = Theme.of(context);

  mediaController.initMediaForm(toUpdateMedia);

  // Controllers are added cause the flutter_typeahead need them to write the text automatically.
  final nameTextController = TextEditingController(
    text: mediaController.name.value,
  );
  final descTextController = TextEditingController(
    text: mediaController.description.value,
  );

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
      surfaceTintColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,
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
              // Api Search Options
              apiSearchOptions(storageService),

              const SizedBox(height: 16),

              // Media Name
              mediaTitle(
                mediaController,
                storageService,
                nameTextController,
                descTextController,
              ),

              const SizedBox(height: 16),

              // Media Description
              mediaDescription(mediaController, descTextController),

              const SizedBox(height: 16),

              // Rating Bar
              ratingWidget(mediaController),

              const SizedBox(height: 16),

              statusSelectorDropdown(mediaController, statusController),

              const SizedBox(height: 16),

              imageSelector(mediaController),
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

  FocusManager.instance.primaryFocus?.unfocus();

  // Disposing
  Future.delayed(const Duration(milliseconds: 500), () {
    nameTextController.dispose();
    descTextController.dispose();
  });
}
