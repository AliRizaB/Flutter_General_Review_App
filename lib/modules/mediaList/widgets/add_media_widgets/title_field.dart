import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:flutter_general_reviewer/services/api_service.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/instance_manager.dart';

Widget mediaTitle(
  MediaController mediaController,
  StorageService storageService,
  TextEditingController nameTextController,
  TextEditingController descTextController,
) {
  final apiService = Get.find<ApiService>();

  return TypeAheadField<AppMedia>(
    controller: nameTextController,
    debounceDuration: const Duration(milliseconds: 400),
    suggestionsCallback: (search) async {
      final activeCategoryKey = storageService.selectedCategoryKey.value;
      return await apiService.searchMedia(
        search,
        activeCategoryKey,
        mediaController.categoryId,
      );
    },
    itemBuilder: (context, AppMedia suggestion) {
      return ListTile(
        title: Text(suggestion.name),
        subtitle: Text(
          suggestion.description ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    },
    onSelected: (AppMedia selectedMedia) {
      nameTextController.text = selectedMedia.name;
      descTextController.text = selectedMedia.description ?? '';

      mediaController.name.value = selectedMedia.name;
      mediaController.description.value = selectedMedia.description ?? '';
      mediaController.imagePath.value = selectedMedia.imagePath ?? '';
    },
    builder: (context, textController, focusNode) {
      return TextFormField(
        controller: textController,
        focusNode: focusNode,
        decoration: InputDecoration(
          labelText: 'Media Name',
          hintText: 'Type to search...',
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) => mediaController.name.value = value,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please Enter A Media Name";
          }
          return null;
        },
      );
    },
  );
}
