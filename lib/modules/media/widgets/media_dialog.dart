// Essentials
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:flutter_general_reviewer/modules/media/widgets/media_form_fields.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/alert_dialog_base.dart';

// App Controllers and Services
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';

// Models
import 'package:flutter_general_reviewer/models/app_media.dart';

Future showMediaDialog(BuildContext context, {AppMedia? toUpdateMedia}) async {
  final mediaController = Get.find<MediaController>();
  final statusController = Get.find<StatusController>();
  final storageService = Get.find<StorageService>();

  if (statusController.statuses.isEmpty) {
    mediaController.showErrorSnackBar(message: 'No Status avaliable');
    return;
  }

  final bool isEditing = (toUpdateMedia != null);
  mediaController.initMediaForm(toUpdateMedia);

  await Get.dialog(
    AlertDialogBase(
      isEditing: isEditing,
      label: mediaController.categoryName,
      onSubmit: () async {
        if (isEditing) {
          await mediaController.updateMedia();
        } else {
          await mediaController.addMedia();
        }
      },
      children: [
        MediaFormFields(
          mediaController: mediaController,
          statusController: statusController,
          storageService: storageService,
        ),
      ],
    ),
  );
  FocusManager.instance.primaryFocus?.unfocus();
}
