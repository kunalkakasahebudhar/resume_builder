import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyState({
    super.key,
    this.icon = Icons.description_outlined,
    required this.title,
    required this.description,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  text: actionText!,
                  icon: Icons.add,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
