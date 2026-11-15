import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/build_button.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/form_buttons.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

Future<void> showDatabaseOptions() async {
  final controller = Get.find<BaseController>();
  final dbService = Get.find<DatabaseService>();

  await Get.dialog(
    AlertDialog(
      title: const Text('Database Options'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          BuildButton(
            icon: Icons.download_outlined,
            label: 'Export Database',
            onTap: () async {
              Get.back();
              final success = await dbService.exportDatabase();
              if (success) {
                controller.showSuccessSnackBar(
                  message: 'Database exported successfully!',
                );
              } else {
                controller.showErrorSnackBar(
                  message: 'Export Cancelled, No backup file was exported.',
                );
              }
            },
          ),
          BuildButton(
            icon: Icons.upload_outlined,
            label: 'Import Database',
            onTap: () async {
              Get.back();
              final success = await dbService.importDatabase();
              if (success) {
                // Fetch the items to initialize it
                if (Get.isRegistered<CategoryController>()) {
                  await Get.find<CategoryController>().fetchCategories();
                }

                controller.showSuccessSnackBar(
                  message: 'Database restored successfully!',
                );
              } else {
                controller.showErrorSnackBar(
                  message:
                      'Import Failed, Failed or cancelled restoring database.',
                );
              }
            },
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [const FormCancelButton()],
    ),
    barrierDismissible: true,
  );
}
