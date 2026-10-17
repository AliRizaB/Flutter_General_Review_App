import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

const Map<String, String?> _apiCategories = {
  'None': null,
  'Game': StorageKeys.apiGame,
  'Movie': StorageKeys.apiMovie,
  'Series': StorageKeys.apiSeries,
  'Anime': StorageKeys.apiAnime,
  'Book': StorageKeys.apiBook,
};

Widget apiSearchOptions(StorageService service) {
  return Wrap(
    spacing: 8.0,
    runSpacing: 4.0,
    children: _apiCategories.entries.map((entry) {
      return Obx(() {
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
      });
    }).toList(),
  );
}
