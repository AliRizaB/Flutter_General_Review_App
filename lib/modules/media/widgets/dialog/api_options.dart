import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

const Map<String, String?> _apiCategories = {
  'None': null,
  'Anime': StorageKeys.apiAnime,
  'Book': StorageKeys.apiBook,
  'Game': StorageKeys.apiGame,
  'Film & TV': StorageKeys.apiMovieAndSeries,
};

class ApiSearchOptions extends GetView<StorageService> {
  const ApiSearchOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8.0,
        runSpacing: 4.0,
        children: _apiCategories.entries.map((entry) {
          return Obx(() {
            final isSelected =
                controller.selectedCategoryKey.value == entry.value;
            return ChoiceChip(
              label: Text(entry.key),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  controller.selectedCategoryKey.value = entry.value;
                }
              },
            );
          });
        }).toList(),
      ),
    );
  }
}
