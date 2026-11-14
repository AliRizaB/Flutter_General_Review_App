// Essentials
import 'package:get/get.dart';

// Widgets
import 'package:flutter_general_reviewer/modules/media/widgets/dialog/media_form_fields.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/alert_dialog_base.dart';

// App Controllers and Services
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';

// Models
import 'package:flutter_general_reviewer/models/app_media.dart';

Future showMediaDialog({AppMedia? toUpdateMedia}) {
  final mediaController = Get.find<MediaController>();
  final statusController = Get.find<StatusController>();

  if (statusController.statuses.isEmpty) {
    mediaController.showErrorSnackBar(message: 'No Status avaliable');
    return Future.value();
  }

  final bool isEditing = (toUpdateMedia != null);
  mediaController.initMediaForm(toUpdateMedia);

  return AlertDialogBase.show(
    isEditing: isEditing,
    label: mediaController.categoryName,
    onSubmit: mediaController.saveMedia,
    children: [MediaFormFields(isEditing: isEditing)],
  );
}
