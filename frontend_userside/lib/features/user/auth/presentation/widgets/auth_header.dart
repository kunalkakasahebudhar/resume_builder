import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Brand Icon / Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.description_rounded,
            size: 30,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'ResumeForge',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
