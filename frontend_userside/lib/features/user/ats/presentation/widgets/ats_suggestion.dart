import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';

class AtsSuggestionList extends StatelessWidget {
  final List<String> suggestions;
  final List<String> detectedKeywords;

  const AtsSuggestionList({
    super.key,
    required this.suggestions,
    this.detectedKeywords = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Improvement Recommendations',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...suggestions.map(
            (suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.8,
                        ),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (detectedKeywords.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Keywords Detected by Parser',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: detectedKeywords
                  .map(
                    (kw) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        kw,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
