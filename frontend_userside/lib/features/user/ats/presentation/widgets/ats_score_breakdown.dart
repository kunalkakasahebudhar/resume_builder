import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';

class AtsScoreBreakdown extends StatelessWidget {
  final AtsAnalysis analysis;

  const AtsScoreBreakdown({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Category Breakdown',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...analysis.categoryScores.map((cat) {
            final percentage = cat.percentage;
            final color = percentage >= 80
                ? const Color(0xFF10B981)
                : percentage >= 60
                ? const Color(0xFFF59E0B)
                : const Color(0xFFEF4444);

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat.categoryName,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${cat.score} / ${cat.maxScore} pts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      minHeight: 6,
                      backgroundColor: theme.colorScheme.outline.withValues(
                        alpha: 0.2,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.feedback,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
