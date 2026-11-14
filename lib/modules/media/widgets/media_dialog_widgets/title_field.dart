import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/modules/shared/form_fields/custom_text_field.dart';
import 'package:flutter_general_reviewer/modules/shared/load_image.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MediaTitleField extends StatefulWidget {
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
  State<MediaTitleField> createState() => _MediaTitleFieldState();
}

class _MediaTitleFieldState extends State<MediaTitleField> {
  final ScrollController _scrollController = ScrollController();

  List<AppMedia> _accumulatedResults = [];
  String _lastQuery = '';
  int _currentPage = 1;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    // Trigger next page when scrolled from 80 px
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 80 &&
        !_isLoadingMore &&
        _hasMore &&
        _lastQuery.length >= 3) {
      setState(() => _isLoadingMore = true);

      _currentPage++;
      final newItems = await widget.mediaController.searchMediaFromApi(
        _lastQuery,
        page: _currentPage,
      );

      if (mounted) {
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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<AppMedia>(
      controller: widget.nameTextController,
      debounceDuration: const Duration(milliseconds: 400),
      suggestionsController: widget.suggestionsController,
      suggestionsCallback: (search) async {
        final query = search.trim();
        if (query.length < 3) {
          _accumulatedResults = [];
          return [];
        }

        // Reset pagination for a new search query
        if (query != _lastQuery) {
          _lastQuery = query;
          _currentPage = 1;
          _hasMore = true;
          _accumulatedResults = await widget.mediaController.searchMediaFromApi(
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
          widget.mediaController.applySelectedMedia(
            selectedMedia: selectedMedia,
            nameController: widget.nameTextController,
            descController: widget.descTextController,
          ),

      builder: (context, textController, focusNode) {
        return CustomTextField(
          labelText: 'Media Name',
          onChanged: (value) => widget.mediaController.name.value = value,
          hintText: 'Type to search...',
          controller: textController,
          focusNode: focusNode,
        );
      },
    );
  }
}
