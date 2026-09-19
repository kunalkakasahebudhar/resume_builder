import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_button.dart';

class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final String retryText;
  final VoidCallback? onRetry;

  const AppErrorState({
    super.key,
    this.title = 'Something went wrong',
    required this.message,
    this.retryText = 'Try Again',
    this.onRetry,
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
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: theme.colorScheme.error,
                ),
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
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                AppButton(
                  text: retryText,
                  icon: Icons.refresh_rounded,
                  type: ButtonType.outline,
                  onPressed: onRetry,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
