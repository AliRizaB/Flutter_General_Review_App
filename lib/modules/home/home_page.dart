import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/category_page.dart';
import 'package:flutter_general_reviewer/modules/home/home_controller.dart';
import 'package:flutter_general_reviewer/modules/home/widget/home_appbar.dart';
import 'package:flutter_general_reviewer/modules/profile/profile_page.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: homeAppBar(context),

      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [CategoryPage(), ProfilePage()],
        ),
      ),

      bottomNavigationBar: Obx(() {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        final navBarColor = isDark
            ? Color.alphaBlend(
                theme.colorScheme.primary.withValues(alpha: 0.22),
                theme.colorScheme.surface,
              )
            : Color.alphaBlend(
                theme.colorScheme.primary.withValues(alpha: 0.12),
                theme.colorScheme.surface,
              );

        return NavigationBar(
          backgroundColor: navBarColor,
          indicatorColor: theme.colorScheme.primaryContainer,
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: controller.changePage,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.shelves),

              label: 'Categories',
            ),
            NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
          ],
        );
      }),
    );
  }
}
