import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';

class AtsCategoryCard extends StatelessWidget {
  final String title;
  final int score;
  final int maxScore;
  final String description;
  final IconData icon;

  const AtsCategoryCard({
    super.key,
    required this.title,
    required this.score,
    required this.maxScore,
    required this.description,
    this.icon = Icons.check_circle_outline,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxScore > 0 ? score / maxScore : 0.0;
    final color = ratio >= 0.8
        ? const Color(0xFF10B981)
        : ratio >= 0.6
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 22),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$score / $maxScore',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
