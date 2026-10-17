import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/custom_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class ApiKeyField extends StatelessWidget {
  final String title;
  final String initialValue;
  final String providerName;
  final String providerUrl;
  final ValueChanged<String?> onSaved;

  const ApiKeyField({
    super.key,
    required this.title,
    required this.initialValue,
    required this.providerName,
    required this.providerUrl,
    required this.onSaved,
  });

  // With url provider
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(providerUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $providerUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          labelText: title,
          hintText: 'Paste $providerName API key here ....',
          initialValue: initialValue,
          onSaved: onSaved,
          validator: (_) => null,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: _launchUrl,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 4, vertical: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Get free key from $providerName',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// No API Key Needed
class NoApiKeyCard extends StatelessWidget {
  final String title;
  final String providerName;
  final IconData icon;

  const NoApiKeyCard({
    super.key,
    required this.title,
    required this.providerName,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Powered by $providerName (No key needed)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Public',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
