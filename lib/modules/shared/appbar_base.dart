import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/app_bar_theme.dart';
class AppBarBase extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const AppBarBase({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      backgroundColor: getAppBarColor(theme),
      foregroundColor: getAppBarForegroundColor(theme),
      title: Text(
        title,
        style: theme.textTheme.headlineMedium!.copyWith(
          color: getAppBarForegroundColor(theme),
          fontFamily: 'Isometra',
        ),
      ),
      actions: actions,
    );
  }
}
