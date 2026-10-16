import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Obx apiSearchOptions(StorageService service) {
  final categories = <String, String?>{
    'None': null,
    'Game': StorageKeys.apiGame,
    'Movie': StorageKeys.apiMovie,
    'Series': StorageKeys.apiSeries,
    'Anime': StorageKeys.apiAnime,
    'Book': StorageKeys.apiBook,
  };

  return Obx(() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: categories.entries.map((entry) {
        final isSelected = service.selectedCategoryKey.value == entry.value;
        return ChoiceChip(
          label: Text(entry.key),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              service.selectedCategoryKey.value = entry.value;
            }
          },
        );
      }).toList(),
    );
  });
}