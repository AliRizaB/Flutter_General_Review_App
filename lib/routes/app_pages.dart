// ignore_for_file: constant_identifier_names

import 'package:flutter_general_reviewer/modules/home/home_binding.dart';
import 'package:flutter_general_reviewer/modules/home/home_page.dart';
import 'package:flutter_general_reviewer/modules/medias/media_binding.dart';
import 'package:flutter_general_reviewer/modules/medias/media_page.dart';
import 'package:flutter_general_reviewer/modules/splash/splash_binding.dart';
import 'package:flutter_general_reviewer/modules/splash/splash_page.dart';
import 'package:get/get.dart';

abstract class AppRoutes {
  static const INITIAL = SPLASH;
  static const SPLASH = '/splash';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const CATEGORY = '/category';
  static const MEDIA = '/media';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.MEDIA,
      page: () => MediaPage(categoryId: Get.arguments[0], categoryName: Get.arguments[1],),
      binding: MediaBinding(),
    ),
  ];
}
