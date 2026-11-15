import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class BuildColorPicker extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const BuildColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Pick Color', style: TextStyle(fontWeight: FontWeight.bold)),
        ColorPicker(
          color: initialColor,
          onColorChanged: onColorChanged,
          wheelDiameter: 250,
          enableShadesSelection: true,
          pickersEnabled: const {
            ColorPickerType.primary: false,
            ColorPickerType.accent: false,
            ColorPickerType.wheel: true,
          },
        ),
      ],
    );
  }
}
