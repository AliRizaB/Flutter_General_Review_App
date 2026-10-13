import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/profile/profile_controller.dart';
import 'package:flutter_general_reviewer/modules/profile/widgets/change_theme_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class ProfilePage extends GetView<ProfileController> {
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
            onTap: _showAPIKeyDialog,
          ),
        ],
      ),
    );
  }

  void _showAPIKeyDialog() {}
}

class BuildButton extends StatelessWidget {
  const BuildButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: onTap,
        icon: Icon(icon, color: theme.colorScheme.onPrimaryContainer),
        label: Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
