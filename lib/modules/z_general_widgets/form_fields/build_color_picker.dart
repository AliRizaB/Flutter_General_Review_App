import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerField extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const ColorPickerField({
    super.key,
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ColorPicker(
        color: initialColor,
        onColorChanged: onColorChanged,
        wheelDiameter: 250,
        enableShadesSelection: true,
        pickersEnabled: const {
          ColorPickerType.primary: false,
          ColorPickerType.accent: false,
          ColorPickerType.wheel: true,
        },
      );
    
  }
}


