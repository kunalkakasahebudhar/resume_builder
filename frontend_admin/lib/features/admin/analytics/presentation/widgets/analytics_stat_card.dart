import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String maxPoints;
  final double percentage;
  final Color color;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.maxPoints,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.label()),
                Text(
                  '$value / $maxPoints pts',
                  style: AppTextStyles.titleSmall(color: color),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: percentage,
              backgroundColor: color.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: 8),
            Text(
              'Avg Score: ${(percentage * 100).toStringAsFixed(0)}% accuracy',
              style: AppTextStyles.bodySmall(),
            ),
          ],
        ),
      ),
    );
  }
}
