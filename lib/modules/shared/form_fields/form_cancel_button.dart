import 'package:flutter/material.dart';

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
