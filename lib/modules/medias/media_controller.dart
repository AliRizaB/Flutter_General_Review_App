import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:get/get.dart';

class MediaController extends BaseController {
  final MediaRepository _mediaRepository = Get.find<MediaRepository>();
  RxList<AppMedia> medias = <AppMedia>[].obs;

  Rx statusId = 0.obs;
  Rx<String> name = ''.obs;
  Rx<int> rating = 0.obs;
  Rx<String> description = ''.obs;
  Rx<String> imagePath = ''.obs;

  late final int categoryId;
  late final String categoryName;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments[0];
    categoryName = Get.arguments[1].toUpperCase();

    setLoading(true);

    fetchMedias();
    setLoading(false);
  }

  Future<void> fetchMedias() async {
    try {
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
        rating: rating.value,
        description: description.value,
      );
      debugPrint(
        "CREATED: ${newMedia.id}, ${newMedia.categoryId}, ${newMedia.name}",
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
