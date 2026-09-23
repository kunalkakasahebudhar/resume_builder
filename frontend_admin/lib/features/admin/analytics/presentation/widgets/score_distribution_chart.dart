import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class ScoreDistributionChart extends StatelessWidget {
  const ScoreDistributionChart({super.key});

  @override
  Widget build(BuildContext context) {
    final distribution = [
      {
        'range': '90 - 100',
        'count': 1420,
        'percent': 0.42,
        'color': AppColors.success,
      },
      {
        'range': '80 - 89',
        'count': 1000,
        'percent': 0.29,
        'color': AppColors.primary,
      },
      {
        'range': '70 - 79',
        'count': 580,
        'percent': 0.17,
        'color': AppColors.secondary,
      },
      {
        'range': '60 - 69',
        'count': 200,
        'percent': 0.06,
        'color': AppColors.warning,
      },
      {
        'range': '< 60',
        'count': 212,
        'percent': 0.06,
        'color': AppColors.error,
      },
    ];

    return Card(
      elevation: 0,
      color: AppColors.card(context),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ATS Score Distribution', style: AppTextStyles.h3()),
            const SizedBox(height: 4),
            Text(
              'Aggregated score ranges for 3,412 generated documents.',
              style: AppTextStyles.bodySmall(),
            ),
            const SizedBox(height: 20),
            Column(
              children: distribution.map((item) {
                final percent = item['percent'] as double;
                final color = item['color'] as Color;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          item['range'] as String,
                          style: AppTextStyles.titleSmall(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: percent,
                            minHeight: 14,
                            backgroundColor: AppColors.backgroundLight,
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 90,
                        child: Text(
                          '${item['count']} (${(percent * 100).toStringAsFixed(0)}%)',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.textPrimaryLight,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
