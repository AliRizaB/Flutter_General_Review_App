// Burada Genel olarak tüm kontrollerda gerçekleşen işlemleri yazabiliriz.
// Daha derli toplu ve sonradan düzenlemesi kolay olur.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseController extends GetxController {
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  void setLoading(bool value) => _isLoading.value = value;

  void showErrorSnackBar({
    required String message,
    String title = "Hata",
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Get.isDarkMode;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      // Soft red styling for errors
      backgroundColor: isDark
          ? const Color(0xFF7A1C1C)
          : const Color(0xFFFFEBEE),
      colorText: isDark ? Colors.white : const Color(0xFFC62828),
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isDark ? Colors.white : const Color(0xFFB71C1C),
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : const Color(0xFFC62828),
        ),
      ),
      icon: Icon(
        Icons.error_rounded,
        color: isDark ? Colors.redAccent.shade100 : const Color(0xFFD32F2F),
        size: 28,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      borderRadius: 12,
      borderWidth: 1,
      borderColor: isDark ? const Color(0xFFB71C1C) : const Color(0xFFFFCDD2),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  void showSuccessSnackBar({
    required String message,
    String title = "Başarılı",
    Duration duration = const Duration(seconds: 3),
  }) {
    final isDark = Get.isDarkMode;

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      // Soft green styling for success
      backgroundColor: isDark
          ? const Color(0xFF1B4D2E)
          : const Color(0xFFE8F5E9),
      colorText: isDark ? Colors.white : const Color(0xFF2E7D32),
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: isDark ? Colors.white : const Color(0xFF1B5E20),
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : const Color(0xFF2E7D32),
        ),
      ),
      icon: Icon(
        Icons.check_circle_rounded,
        color: isDark ? Colors.greenAccent.shade200 : const Color(0xFF388E3C),
        size: 28,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      borderRadius: 12,
      borderWidth: 1,
      borderColor: isDark ? const Color(0xFF2E7D32) : const Color(0xFFC8E6C9),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      duration: duration,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
