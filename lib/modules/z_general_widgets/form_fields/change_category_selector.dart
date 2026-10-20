import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeCategorySelector<T> extends StatelessWidget {
  final bool isEdit;
  final List<T> listValues;
  final int? selectedId;
  final ValueChanged<int?> onChanged;
  final int? Function(T item) getItemId;
  final String Function(T item) getItemLabel;

  const ChangeCategorySelector({
    super.key,
    required this.isEdit,
    required this.onChanged,

    required this.selectedId,
    required this.listValues,
    required this.getItemId,
    required this.getItemLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEdit) {
      return const SizedBox.shrink();
    }

    return Obx(() {
      final T? selectedValue = listValues.firstWhereOrNull(
        (element) => getItemId(element) == selectedId,
      );

      return DropdownButtonFormField<int>(
        initialValue: selectedValue != null ? getItemId(selectedValue) : null,
        decoration: const InputDecoration(
          labelText: 'Select Category',
          border: OutlineInputBorder(),
        ),
        items: listValues
            .map(
              (element) => DropdownMenuItem(
                value: getItemId(element),
                child: Text(getItemLabel(element)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      );
    });
  }
}
