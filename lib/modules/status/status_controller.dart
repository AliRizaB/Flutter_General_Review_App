import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/repository/status_repo.dart';
import 'package:get/get.dart';

class StatusController extends BaseController {
  final StatusRepository _statusRepository = Get.find<StatusRepository>();
  RxList<MediaStatus> statuses = <MediaStatus>[].obs;

  // Status Attributes
  int? statusId;
  Rx<String> statusName = ''.obs;
  Rx<Color> statusColor = const Color(0xff443a49).obs;

  @override
  void onInit() {
    super.onInit();
    setLoading(true);
    fetchStatuses();
    setLoading(false);
  }

  void initStatusForm(MediaStatus? status) {
    if (status != null) {
      statusId = status.id;
      statusName.value = status.name;
      statusColor.value = status.getColor;
    } else {
      statusName.value = '';
      statusColor.value = const Color(0xff443a49);
    }
  }

  Future<void> fetchStatuses() async {
    try {
      final list = await _statusRepository.getStatuses();
      statuses.assignAll(list);
    } catch (e) {
      showErrorSnackBar(
        message: "Error: while Getting the Statuses \nERROR: ${e.toString()}",
      );
    }
  }

  Color getStatusColor(int? id) {
    try {
      if (id == null) {
        return Colors.grey;
      }
      final status = statuses.firstWhereOrNull((element) => element.id == id);
      return status?.getColor ?? Colors.grey;
    } catch (e) {
      showErrorSnackBar(
        message: "Error: while Getting the Statuses \nERROR: ${e.toString()}",
      );
      return Colors.grey;
    }
  }

  Future<void> addStatus() async {
    try {
      setLoading(true);
      final newStatus = MediaStatus(
        name: statusName.value,
        color: statusColor.value.hex,
      );
      debugPrint("CREATED: ${newStatus.id}, ${newStatus.name}");
      await _statusRepository.addStatus(newStatus);
      await fetchStatuses();
      showSuccessSnackBar(message: "Succesfully Created Status");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Creating Statuss \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateStatus() async {
    try {
      setLoading(true);
      if (statusId == null) {
        showErrorSnackBar(message: "No status selected to update");
        return;
      }
      final updatedStatus = MediaStatus(
        id: statusId,
        name: statusName.value,
        color: statusColor.value.hex,
      );
      await _statusRepository.updateStatus(updatedStatus);
      await fetchStatuses();
      showSuccessSnackBar(message: "Succesfully Updated Status");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Statuss \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteStatus(int id) async {
    try {
      setLoading(true);
      await _statusRepository.deleteStatus(id);
      await fetchStatuses();
      showSuccessSnackBar(message: "Succesfully Deleted Status");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Statuss \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}
