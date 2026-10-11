import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/status_controller.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:get/get.dart';

// Image Picking
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class MediaListController extends BaseController {
  final MediaRepository _mediaRepository = Get.find<MediaRepository>();
  RxList<AppMedia> medias = <AppMedia>[].obs;

  int? mediaId;
  Rx<int?> statusId = (-1).obs;
  Rx<String> name = ''.obs;
  Rx<int> rating = 1.obs;
  Rx<String> description = ''.obs;
  Rx<String> imagePath = ''.obs;

  late final int categoryId;
  late final String categoryName;

  @override
  void onInit() {
    super.onInit();
    setLoading(true);
    categoryId = Get.arguments[0];
    categoryName = Get.arguments[1];
    fetchMedias();
    setLoading(false);
  }

  // For Media Dialog If there is update or create
  void initMediaForm(AppMedia? media) {
    if (media != null) {
      mediaId = media.id;
      name.value = media.name;
      description.value = media.description ?? '';
      rating.value = media.rating;
      statusId.value = media.statusId;
      imagePath.value = media.imagePath ?? 'assets/images/noImage.jpg';
    } else {
      mediaId = null;
      name.value = '';
      description.value = '';
      rating.value = 1;
      statusId.value = -1;
      imagePath.value = '';
    }
  }

  // Image Picking Operation
  Future<void> pickAndSaveImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80, // Optional compression
      );

      if (pickedFile == null) return; // User canceled

      // 1. Get permanent storage directory
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      // 2. Build unique filename using timestamp to prevent overwriting
      final String extension = path.extension(pickedFile.path);
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}$extension';
      final String savedPath = path.join(appDocDir.path, fileName);

      // 3. Copy temporary file to permanent directory
      final File permanentImage = await File(pickedFile.path).copy(savedPath);

      // 4. Save path to controller state
      imagePath.value = permanentImage.path;
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // CRUD OPERATIONS
  Future<void> fetchMedias() async {
    try {
      await Get.find<StatusController>().fetchStatuses();

      final list = await _mediaRepository.getMedias(categoryId);
      medias.assignAll(list);
    } catch (e) {
      showErrorSnackBar(
        message: "Error: while Getting the Medias \nERROR: ${e.toString()}",
      );
    }
  }

  Future<void> addMedia() async {
    try {
      setLoading(true);
      final newMedia = AppMedia(
        name: name.value,
        categoryId: categoryId,
        statusId: statusId.value,
        rating: rating.value,
        description: description.value,
        imagePath: imagePath.value,
      );
      debugPrint(
        "CREATED: ${newMedia.id}, ${newMedia.categoryId}, ${newMedia.name}, ${newMedia.rating}",
      );
      await _mediaRepository.addMedia(newMedia);
      await fetchMedias();
      showSuccessSnackBar(message: "Succesfully Created Media");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Creating Medias \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateMedia() async {
    try {
      setLoading(true);
      final updatedMedia = AppMedia(
        id: mediaId ?? (throw ("Media ID is null")),
        statusId: statusId.value,
        name: name.value,
        categoryId: categoryId,
        rating: rating.value,
        description: description.value,
      );
      await _mediaRepository.updateMedia(updatedMedia);
      await fetchMedias();
      showSuccessSnackBar(message: "Succesfully Updated Media");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Medias \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteMedia(int id) async {
    try {
      setLoading(true);
      await _mediaRepository.deleteMedia(id);
      await fetchMedias();
      showSuccessSnackBar(message: "Succesfully Deleted Media");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Medias \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}
