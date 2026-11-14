// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controllers & Services
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/repositories/media_repo.dart';
import 'package:flutter_general_reviewer/services/api_service.dart';
import 'package:flutter_general_reviewer/services/storage_service.dart';

// Helper Wigdets
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:image_picker/image_picker.dart';

// Model
import 'package:flutter_general_reviewer/models/app_media.dart';

class MediaController extends BaseController {
  final MediaRepository _mediaRepository = Get.find<MediaRepository>();
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  RxList<AppMedia> medias = <AppMedia>[].obs;

  // form State
  int? mediaId;
  Rx<int?> statusId = (-1).obs;
  Rx<String> name = ''.obs;
  Rx<int> rating = 1.obs;
  Rx<String> description = ''.obs;
  Rx<String> imagePath = ''.obs;
  String? _originalImagePath;

  // Route Arguments
  Rx<int> categoryId = RxInt(0);
  late final String categoryName;

  // Media Dialog Controlls
  final nameTextController = TextEditingController();
  final descTextController = TextEditingController();
  final suggestionsController = SuggestionsController<AppMedia>();
  late final Worker _apiKeyWorker;

  @override
  void onInit() {
    super.onInit();
    _parseArguments();
    fetchMedias();

    // EveryTime The API Key changes in the Dialog refreshes suggestion Box
    _apiKeyWorker = ever(
      _storageService.selectedCategoryKey,
      (_) => suggestionsController.refresh(),
    );
  }

  void _parseArguments() {
    if (Get.arguments != null && Get.arguments is List) {
      categoryId.value = Get.arguments[0] as int;
      categoryName = Get.arguments[1] as String;
    } else {
      categoryName = 'Category';
    }
  }

  @override
  void onClose() {
    nameTextController.dispose();
    descTextController.dispose();
    suggestionsController.dispose();
    _apiKeyWorker.dispose();
    super.onClose();
  }

  Future<void> saveMedia() async {
    if (mediaId != null) {
      await updateMedia();
    } else {
      await addMedia();
    }
  }

  void initMediaForm(AppMedia? media) {
    mediaId = media?.id;
    name.value = media?.name ?? '';
    description.value = media?.description ?? '';
    rating.value = media?.rating ?? 1;
    statusId.value = media?.statusId ?? -1;
    imagePath.value = media?.imagePath ?? '';
    _originalImagePath = media?.imagePath;
    if (media != null) categoryId.value = media.categoryId;

    // SynchFields
    nameTextController.text = name.value;
    descTextController.text = description.value;
  }

  // Api Search
  Future<List<AppMedia>> searchMediaFromApi(
    String query, {
    int page = 1,
  }) async {
    try {
      final activeCategoryKey = _storageService.selectedCategoryKey.value;
      return await _apiService.searchMedia(
        query,
        activeCategoryKey,
        categoryId.value,
        page,
      );
    } catch (e) {
      return [];
    }
  }

  // Api Select
  void applySelectedMedia({required AppMedia selectedMedia}) {
    // For the Update Media API deletes the Id and the image Path
    final preserveId = mediaId;
    final preserveImg = _originalImagePath;
    final preserveRating = rating.value;
    final preserveStatusId = statusId.value;

    initMediaForm(selectedMedia);

    // For the Update Media API deletes the Id and the image Path
    if (preserveId != null) {
      mediaId = preserveId;
      _originalImagePath = preserveImg;
      rating.value = preserveRating;
      statusId.value = preserveStatusId;
    }
  }

  // CRUD OPERATIONS
  Future<void> fetchMedias() async {
    await super.runAction(
      action: () async {
        final list = await _mediaRepository.getMedias(categoryId.value);
        medias.assignAll(list);
      },
      errorMsg: "Error: while Getting the Medias",
      loading: false,
    );
  }

  Future<void> addMedia() async {
    await super.runAction(
      action: () async {
        final newMedia = AppMedia(
          name: name.value,
          categoryId: categoryId.value,
          statusId: statusId.value,
          rating: rating.value,
          description: description.value,
          imagePath: imagePath.value.isEmpty ? null : imagePath.value,
        );
        await _mediaRepository.addMedia(newMedia);
        await fetchMedias();
      },
      errorMsg: "Error: While Creating Media",
      successMsg: "Successfully Created Media",
    );
  }

  Future<void> updateMedia() async {
    await super.runAction(
      action: () async {
        final String? newImage = imagePath.value.isEmpty
            ? null
            : imagePath.value;

        final updatedMedia = AppMedia(
          id: mediaId ?? (throw ("Media ID is null")),
          statusId: statusId.value,
          name: name.value,
          categoryId: categoryId.value,
          rating: rating.value,
          description: description.value,
          imagePath: newImage,
        );
        await _mediaRepository.updateMedia(updatedMedia);

        if (_originalImagePath != null && _originalImagePath != newImage) {
          await _storageService.deleteImageFile(_originalImagePath);
        }

        await fetchMedias();
      },
      errorMsg: "Error: While Updating Media",
      successMsg: "Successfully Updated Media",
    );
  }

  // Takes the whole media now (was: int id) so its image file can be deleted.
  Future<void> deleteMedia(AppMedia media) async {
    await super.runAction(
      action: () async {
        await _mediaRepository.deleteMedia(media.id!);
        await _storageService.deleteImageFile(media.imagePath);
        await fetchMedias();
      },
      errorMsg: "Error: While Deleting Media",
      successMsg: "Successfully Deleted Media",
    );
  }

  // Image Saving
  Future<void> saveImage(ImageSource source) async {
    await super.runAction(
      action: () async {
        final savedPath = await _storageService.pickAndSaveImage(source);
        if (savedPath != null) imagePath.value = savedPath;
      },
      errorMsg: "Failed to save image",
    );
  }

  // Helper
  AppMedia resolveMedia(AppMedia fallbackMedia) =>
      medias.firstWhereOrNull((media) => media.id == fallbackMedia.id) ??
      fallbackMedia;
}
