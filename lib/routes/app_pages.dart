// ignore_for_file: constant_identifier_names

import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_binding.dart';
import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_page.dart';
import 'package:get/get.dart';

// Home
import 'package:flutter_general_reviewer/modules/home/home_binding.dart';
import 'package:flutter_general_reviewer/modules/home/home_page.dart';

// Media
import 'package:flutter_general_reviewer/modules/media/media_binding.dart';
import 'package:flutter_general_reviewer/modules/media/media_list_page.dart';
import 'package:flutter_general_reviewer/modules/media/widgets/media_page.dart';

// Review
import 'package:flutter_general_reviewer/modules/review/review_binding.dart';
import 'package:flutter_general_reviewer/modules/review/review_list.dart';

// Status
import 'package:flutter_general_reviewer/modules/status/status_binding.dart';
import 'package:flutter_general_reviewer/modules/status/status_page.dart';

abstract class AppRoutes {
  static const INITIAL = HOME;
  static const HOME = '/home';
  static const SUBCATEGORIES = '/subCategories';
  static const MEDIAS = '/medias';
  static const MEDIA = '/mediaView';
  static const REVIEWS = '/review';
  static const STATUS = '/status';
}

class AppPages {
  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SUBCATEGORIES,
      page: () => SubCategoryPage(),
      binding: SubCategoryBinding(),
    ),
    GetPage(
      name: AppRoutes.MEDIAS,
      page: () => MediaListPage(),
      binding: MediaBinding(),
    ),
    GetPage(
      name: AppRoutes.MEDIA,
      page: () => MediaPage(),
      binding: MediaBinding(),
    ),
    GetPage(
      name: AppRoutes.REVIEWS,
      page: () => ReviewList(),
      binding: ReviewBinding(),
    ),
    GetPage(
      name: AppRoutes.STATUS,
      page: () => StatusPage(),
      binding: StatusBinding(),
    ),
  ];
}
