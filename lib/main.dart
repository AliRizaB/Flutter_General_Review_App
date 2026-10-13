import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_binding.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database BEFORE the first frame, so nothing runs without it.

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BaseBinding(),
      theme: FlexThemeData.dark(scheme: FlexScheme.gold),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.INITIAL,
    );
  }
}
