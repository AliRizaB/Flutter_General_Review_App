import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/change_theme_widgets/theme_mode_selection.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/change_theme_widgets/theme_scheme_selection.dart';
import 'package:flutter_general_reviewer/services/theme_service.dart';
import 'package:get/get.dart';

void showChangeThemeDialog() {
  final themeService = Get.find<ThemeService>();

  Get.dialog(
    AlertDialog(
      title: const Text('Theme Settings'),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mode',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              themeModeSelection(themeService),

              const SizedBox(height: 16),

              const Text(
                'Color Scheme',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: themeService.availableSchemes.length,
                itemBuilder: (context, index) {
                  final scheme = themeService.availableSchemes[index];
                  return themeSchemeSelection(themeService, scheme, context);
                },
              ),
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(
              color: Theme.of(Get.context!).colorScheme.primary,
              width: 2,
            ),
          ),
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
