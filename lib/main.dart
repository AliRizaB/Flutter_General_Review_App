import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_binding.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.dark(),
      initialBinding: BaseBinding(),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.INITIAL,
    );
  }
}
