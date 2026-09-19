import 'package:flutter/material.dart';
import 'package:frontend_userside/core/widgets/app_card.dart';
import 'package:frontend_userside/features/user/ats/domain/entities/ats_analysis.dart';
import 'package:frontend_userside/features/user/ats/presentation/widgets/ats_progress_indicator.dart';

class AtsScoreCard extends StatelessWidget {
  final AtsAnalysis analysis;

  const AtsScoreCard({super.key, required this.analysis});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      padding: const EdgeInsets.all(28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AtsProgressIndicator(score: analysis.overallScore),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'ATS Readability & Match Score',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message:
                          'Transparent 100-point benchmark measuring formatting, structure, and machine keywords.',
                      child: Icon(
                        Icons.info_outline,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'This score indicates how cleanly Automated Applicant Tracking Systems (ATS) can parse, read, and extract information from your resume.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '💡 Note: This is an objective technical readability index, not a guarantee of employer hiring decisions.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
