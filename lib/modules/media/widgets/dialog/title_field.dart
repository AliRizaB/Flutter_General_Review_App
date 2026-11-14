// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers & Model
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';

// Widgets & Helper Functions
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';
import 'package:flutter_general_reviewer/modules/shared/functions/load_image.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MediaTitleField extends StatefulWidget {
  const MediaTitleField({super.key});

  @override
  State<MediaTitleField> createState() => _MediaTitleFieldState();
}

class _MediaTitleFieldState extends State<MediaTitleField> {
  final MediaController _controller = Get.find<MediaController>();
  final StorageService _storageService = Get.find<StorageService>();
  final ScrollController _scrollController = ScrollController();

  List<AppMedia> _accumulatedResults = [];
  String _lastQuery = '';
  String? _lastApiKey;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    // Trigger next page when scrolled from 80 px
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 80 &&
        !_isLoadingMore &&
        _hasMore &&
        _lastQuery.length >= 3) {
      setState(() => _isLoadingMore = true);
      _currentPage++;

      final newItems = await _controller.searchMediaFromApi(
        _lastQuery,
        page: _currentPage,
      );

      if (!mounted) return;
      setState(() {
        if (newItems.isEmpty) {
          _hasMore = false;
        } else {
          _accumulatedResults.addAll(newItems);
        }
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<AppMedia>(
      controller: _controller.nameTextController,
      debounceDuration: const Duration(milliseconds: 400),
      suggestionsController: _controller.suggestionsController,
      suggestionsCallback: (search) async {
        final query = search.trim();
        final currentApiKey = _storageService.selectedCategoryKey.value;

        if (query.length < 3 || currentApiKey == null) {
          _accumulatedResults = [];
          _lastQuery = '';
          return [];
        }

        // Reset pagination for a new search query
        if (query != _lastQuery || currentApiKey != _lastApiKey) {
          _lastQuery = query;
          _lastApiKey = currentApiKey;
          _currentPage = 1;
          _hasMore = true;
          _accumulatedResults = await _controller.searchMediaFromApi(
            query,
            page: 1,
          );
        }

        return _accumulatedResults;
      },

      // Intercept the suggestion list rendering to inject ScrollController and loading indicator
      listBuilder: (context, children) {
        return ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: children.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == children.length) {
              return const Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.0),
                  ),
                ),
              );
            }
            return children[index];
          },
        );
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
            borderRadius: BorderRadius.circular(8),
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
          _controller.applySelectedMedia(selectedMedia: selectedMedia),

      builder: (context, textController, focusNode) {
        return CustomTextField(
          labelText: 'Media Name',
          onChanged: (value) => _controller.name.value = value,
          hintText: 'Type to search...',
          controller: textController,
          focusNode: focusNode,
        );
      },
    );
  }
}
