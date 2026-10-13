import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:flutter_general_reviewer/services/preference_service.dart';
import 'package:flutter_general_reviewer/services/theme_service.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database BEFORE the first frame, so nothing runs without it.
  await Get.putAsync<DatabaseService>(
    () => DatabaseService().init(),
    permanent: true,
  );
  await Get.putAsync<PreferenceService>(
    () => PreferenceService().init(),
    permanent: true,
  );
  await Get.putAsync<ThemeService>(
    () async => ThemeService().init(),
    permanent: true,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        theme: FlexThemeData.light(
          scheme: themeService.currentScheme.value,
          useMaterial3: true,
        ),
        darkTheme: FlexThemeData.dark(
          scheme: themeService.currentScheme.value,
          useMaterial3: true,
        ),
        themeMode: themeService.themeMode.value,
        getPages: AppPages.pages,
        initialRoute: AppRoutes.INITIAL,
      ),
    );
  }
}
