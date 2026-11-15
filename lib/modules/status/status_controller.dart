import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/repositories/status_repo.dart';
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

  Future<void> onSubmit() async {
    if (statusId != null) {
      await updateStatus();
    } else {
      await addStatus();
    }
  }

  void initStatusForm(MediaStatus? status) {
    statusId = status?.id;
    statusName.value = status?.name ?? '';
    statusColor.value = status?.getColor ?? const Color(0xff443a49);
  }

  // CRUD operations
  Future<void> fetchStatuses() async {
    await super.runAction(
      action: () async {
        final list = await _statusRepository.getStatuses();
        statuses.assignAll(list);
      },
      errorMsg: "Error: while Getting the Statuses",
    );
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
        message:
            "Error: while Getting the Status Color \nERROR: ${e.toString()}",
      );
      return Colors.grey;
    }
  }

  Future<void> addStatus() async {
    await super.runAction(
      action: () async {
        final newStatus = MediaStatus(
          name: statusName.value,
          color: statusColor.value.hex,
        );
        await _statusRepository.addStatus(newStatus);
        await fetchStatuses();
      },
      errorMsg: "Error: While Creating Status",
      successMsg: "Succesfully Created Status",
    );
  }

  Future<void> updateStatus() async {
    await super.runAction(
      action: () async {
        final updatedStatus = MediaStatus(
          id: statusId,
          name: statusName.value,
          color: statusColor.value.hex,
        );
        await _statusRepository.updateStatus(updatedStatus);
        await fetchStatuses();
      },
      errorMsg: "Error: While Updating Status",
      successMsg: "Succesfully Updated Status",
    );
  }

  Future<void> deleteStatus(int id) async {
    await super.runAction(
      action: () async {
        await _statusRepository.deleteStatus(id);
        await fetchStatuses();
      },
      errorMsg: "Error: While Deleting Status",
      successMsg: "Succesfully Deleted Status",
    );
  }
}
