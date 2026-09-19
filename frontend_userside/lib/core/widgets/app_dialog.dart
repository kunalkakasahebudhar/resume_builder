import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;
  final bool isLoading;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
    this.isLoading = false,
  });

  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 440),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  height: 1.5,
                ),
              ),
            ],
            if (content != null) ...[const SizedBox(height: 16), content!],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: cancelText,
                  type: ButtonType.outline,
                  onPressed: onCancel ?? () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                AppButton(
                  text: confirmText,
                  type: isDestructive ? ButtonType.danger : ButtonType.primary,
                  isLoading: isLoading,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
