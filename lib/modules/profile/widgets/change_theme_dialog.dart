import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/get_scheme_name.dart';
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
              // --- 1. Light / Dark / System Mode Toggle ---
              const Text(
                'Mode',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.light,
                        icon: Icon(Icons.wb_sunny_outlined, size: 18),
                        label: Text('Light', style: TextStyle(fontSize: 12)),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        icon: Icon(Icons.dark_mode_outlined, size: 18),
                        label: Text('Dark', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                    selected: {themeService.themeMode.value},
                    onSelectionChanged: (newSelection) {
                      themeService.changeThemeMode(newSelection.first);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- 2. Color Schemes Grid ---
              const Text(
                'Color Scheme',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Scroll managed by SingleChildScrollView
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: themeService.availableSchemes.length,
                itemBuilder: (context, index) {
                  final scheme = themeService.availableSchemes[index];
                  return Obx(() {
                    final isSelected =
                        themeService.currentScheme.value == scheme;
                    final schemeColors = FlexColor.schemes[scheme]!.light;

                    return InkWell(
                      onTap: () => themeService.changeScheme(scheme),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outlineVariant,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            // Primary color dot
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: schemeColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                getSchemeName(scheme),
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isSelected)
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  });
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
              width: 2, // Border width
            ),
          ),
          onPressed: () => Get.back(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
