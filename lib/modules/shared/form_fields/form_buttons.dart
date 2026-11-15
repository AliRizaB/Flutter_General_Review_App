import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isEditing;
  final Future<void> Function() onSubmit;

  const FormSubmitButton({
    super.key,
    required this.formKey,
    required this.isEditing,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;

        FocusManager.instance.primaryFocus?.unfocus();

        await onSubmit();

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Text(isEditing ? 'Update' : 'Create'),
    );
  }
}

class FormCancelButton extends StatelessWidget {
  final VoidCallback? onCancel;

  const FormCancelButton({super.key, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();

        if (onCancel != null) {
          onCancel!();
        } else {
          Navigator.of(context).pop();
        }
      },
      child: const Text('Cancel'),
    );
  }
}
