import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/theme_service.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

// Change Theme Mode Dark/Light
Obx themeModeSelection(ThemeService themeService) {
  return Obx(
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
  );
}

// Select the Schema Like Amber, Forest, ...
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

// Registered Schemas in the 
String getSchemeName(FlexScheme scheme) {
  switch (scheme) {
    // Modern Tech & Cyber
    case FlexScheme.ebonyClay:
      return 'Ebony Cyber';
    case FlexScheme.outerSpace:
      return 'Outer Space';
    case FlexScheme.deepBlue:
      return 'Deep Tech Blue';
    case FlexScheme.blumineBlue:
      return 'Blumine Blue';
    case FlexScheme.shark:
      return 'Slate & Charcoal';
    case FlexScheme.aquaBlue:
      return 'Ocean Aqua';

    // Reds, Pinks & Purples
    case FlexScheme.barossa:
      return 'Barossa Wine';
    case FlexScheme.mandyRed:
      return 'Mandy Coral';
    case FlexScheme.redWine:
      return 'Burgundy Red';
    case FlexScheme.sakura:
      return 'Sakura Pink';
    case FlexScheme.indigo:
      return 'Modern Indigo';
    case FlexScheme.deepPurple:
      return 'Deep Purple';
    case FlexScheme.purpleM3:
      return 'Royal Purple';

    // Greens & Teals
    case FlexScheme.wasabi:
      return 'Wasabi Sage';
    case FlexScheme.jungle:
      return 'Jungle Green';
    case FlexScheme.green:
      return 'Forest Green';
    case FlexScheme.money:
      return 'Money Mint';
    case FlexScheme.shadGreen:
      return 'Shad Green';

    // Warm Earthy & Sunsets
    case FlexScheme.mango:
      return 'Mango Sunset';
    case FlexScheme.amber:
      return 'Amber Gold';
    case FlexScheme.espresso:
      return 'Espresso Mocha';
    case FlexScheme.damask:
      return 'Copper Terracotta';

    // Standards
    case FlexScheme.greyLaw:
      return 'Slate Grey';
    case FlexScheme.material:
    default:
      return 'Standard Material';
  }
}
