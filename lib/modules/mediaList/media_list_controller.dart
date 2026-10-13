import 'dart:io';

import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:get/get.dart';
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

  String? _originalImagePath;

  late final int categoryId;
  late final String categoryName;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments[0];
    categoryName = Get.arguments[1];
    fetchMedias();
  }

  void initMediaForm(AppMedia? media) {
    if (media != null) {
      mediaId = media.id;
      name.value = media.name;
      description.value = media.description ?? '';
      rating.value = media.rating;
      statusId.value = media.statusId ?? -1;
      imagePath.value = media.imagePath ?? '';
      _originalImagePath = media.imagePath;
    } else {
      mediaId = null;
      name.value = '';
      description.value = '';
      rating.value = 1;
      statusId.value = -1;
      imagePath.value = '';
      _originalImagePath = null;
    }
  }

  Future<void> pickAndSaveImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1200,
        maxHeight: 1200,
      );

      if (pickedFile == null) return;

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String extension = path.extension(pickedFile.path);
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}$extension';
      final String savedPath = path.join(appDocDir.path, fileName);

      final File permanentImage = await File(pickedFile.path).copy(savedPath);
      imagePath.value = permanentImage.path;
    } catch (e) {
      showErrorSnackBar(message: 'Failed to pick image: $e');
    }
  }

  Future<void> _deleteImageFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return;
    try {
      final file = File(filePath);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Not critical
    }
  }

  // CRUD OPERATIONS
  Future<void> fetchMedias() async {
    try {
      setLoading(true);
      await Get.find<StatusController>().fetchStatuses();
      final list = await _mediaRepository.getMedias(categoryId);
      medias.assignAll(list);
    } catch (e) {
      showErrorSnackBar(
        message: "Error: while Getting the Medias \nERROR: ${e.toString()}",
      );
    } finally {
      setLoading(false);
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
        imagePath: imagePath.value.isEmpty ? null : imagePath.value,
      );
      await _mediaRepository.addMedia(newMedia);
      await fetchMedias();
      showSuccessSnackBar(message: "Successfully Created Media");
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
      final String? newImage = imagePath.value.isEmpty ? null : imagePath.value;

      final updatedMedia = AppMedia(
        id: mediaId ?? (throw ("Media ID is null")),
        statusId: statusId.value,
        name: name.value,
        categoryId: categoryId,
        rating: rating.value,
        description: description.value,
        imagePath: newImage, // <- was missing, which wiped the photo
      );
      await _mediaRepository.updateMedia(updatedMedia);

      // Photo was replaced or removed -> delete the old file
      if (_originalImagePath != null && _originalImagePath != newImage) {
        await _deleteImageFile(_originalImagePath);
      }

      await fetchMedias();
      showSuccessSnackBar(message: "Successfully Updated Media");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Medias \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  // Takes the whole media now (was: int id) so its image file can be deleted.
  Future<void> deleteMedia(AppMedia media) async {
    try {
      setLoading(true);
      await _mediaRepository.deleteMedia(media.id!);
      await _deleteImageFile(media.imagePath);
      await fetchMedias();
      showSuccessSnackBar(message: "Successfully Deleted Media");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Medias \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}
