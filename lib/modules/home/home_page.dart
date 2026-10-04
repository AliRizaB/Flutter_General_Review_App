import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/category_page.dart';
import 'package:flutter_general_reviewer/modules/home/home_controller.dart';
import 'package:flutter_general_reviewer/modules/home/widget/dialog_add_category.dart';
import 'package:flutter_general_reviewer/modules/profile/profile_page.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Review App"),
        actions: [
          IconButton(
            onPressed: () async => showAddCategoryDialog(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [CategoryPage(), ProfilePage()],
        ),
      ),

      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.shelves),
              label: 'Categories',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
