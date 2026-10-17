import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/form_cancel_button.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/form_fields/form_submit_button.dart';

class AlertDialogBase extends StatefulWidget {
  final bool isEditing;
  final String label;

  final Future<void> Function() onSubmit;

  final List<Widget> children;
  const AlertDialogBase({
    super.key,
    required this.isEditing,
    required this.label,
    required this.onSubmit,
    required this.children,
  });

  @override
  State<AlertDialogBase> createState() => _AlertDialogBaseState();
}

// Turn it into a Statefull cause it will be better to use formKey performace wise
class _AlertDialogBaseState extends State<AlertDialogBase> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      surfaceTintColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.surface,

      title: Text(
        widget.isEditing ? 'Update ${widget.label}' : 'Add New ${widget.label}',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          ),
        ),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        const FormCancelButton(),

        FormSubmitButton(
          formKey: _formKey,
          isEditing: widget.isEditing,
          onSubmit: widget.onSubmit,
        ),
      ],
    );
  }
}
