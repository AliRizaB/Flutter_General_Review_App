import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/theme_service.dart';
import 'package:flutter_general_reviewer/utilities/get_scheme_name.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Obx themeSchemeSelection(
  ThemeService themeService,
  FlexScheme scheme,
  BuildContext context,
) {
  return Obx(() {
    final isSelected = themeService.currentScheme.value == scheme;
    final schemeColors = FlexColor.schemes[scheme]!.light;

    return InkWell(
      onTap: () => themeService.changeScheme(scheme),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
}
