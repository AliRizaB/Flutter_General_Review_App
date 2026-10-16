import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/api_key_dialog.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/build_button.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/change_theme_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 12.0,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BuildButton(
            icon: Icons.palette,
            label: 'Change Theme',
            onTap: showChangeThemeDialog,
          ),

          BuildButton(
            icon: Icons.bookmark,
            label: 'Status Options',
            onTap: () => Get.toNamed(AppRoutes.STATUS),
          ),

          BuildButton(
            icon: Icons.key,
            label: 'Add API Keys',
            onTap: showAPIKeyDialog,
          ),
        ],
      ),
    );
  }
}
