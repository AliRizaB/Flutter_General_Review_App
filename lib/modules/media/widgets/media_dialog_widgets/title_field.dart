import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/load_image.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MediaTitleField extends StatelessWidget {
  final MediaController mediaController;
  final TextEditingController nameTextController;
  final TextEditingController descTextController;
  final SuggestionsController<AppMedia> suggestionsController;

  const MediaTitleField({
    super.key,
    required this.mediaController,
    required this.nameTextController,
    required this.descTextController,
    required this.suggestionsController,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<AppMedia>(
      controller: nameTextController,
      debounceDuration: const Duration(milliseconds: 400),
      suggestionsController: suggestionsController,
      suggestionsCallback: (search) async {
        final query = search.trim();
        if (query.length < 3) return [];
        return await mediaController.searchMediaFromApi(search);
      },

      loadingBuilder: (context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),

      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No items found. You can enter details manually.',
          style: TextStyle(color: Colors.grey),
        ),
      ),

      itemBuilder: (context, AppMedia suggestion) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(8),
            child: SizedBox(
              width: 44,
              height: 60,
              child: loadImage(suggestion.imagePath, BoxFit.contain),
            ),
          ),
          title: Text(suggestion.name),
          subtitle:
              (suggestion.description != null &&
                  suggestion.description!.isNotEmpty)
              ? Text(
                  suggestion.description!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
        );
      },
      onSelected: (AppMedia selectedMedia) =>
          mediaController.applySelectedMedia(
            selectedMedia: selectedMedia,
            nameController: nameTextController,
            descController: descTextController,
          ),
      builder: (context, textController, focusNode) {
        return CustomTextField(
          labelText: 'Media Name',
          onChanged: (value) => mediaController.name.value = value,
          hintText: 'Type to search...',
          controller: textController,
          focusNode: focusNode,
        );
      },
    );
  }
}
