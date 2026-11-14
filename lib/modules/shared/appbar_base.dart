import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/functions/app_bar_theme.dart';

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
      title: AutoSizeText(
        title,
        maxLines: 2,
        maxFontSize: 20,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.headlineMedium!.copyWith(
          color: getAppBarForegroundColor(theme),
          fontFamily: 'Isometra',
          height: 1.1,
        ),
      ),

      actions: actions,
    );
  }
}
