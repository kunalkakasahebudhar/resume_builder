import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class AtsScoreChart extends StatelessWidget {
  const AtsScoreChart({super.key});

  @override
  Widget build(BuildContext context) {
    final monthlyData = [
      {'month': 'Apr', 'avg': 79.2, 'total': 340},
      {'month': 'May', 'avg': 81.0, 'total': 480},
      {'month': 'Jun', 'avg': 82.5, 'total': 620},
      {'month': 'Jul', 'avg': 83.1, 'total': 710},
      {'month': 'Aug', 'avg': 84.0, 'total': 890},
      {'month': 'Sep', 'avg': 84.6, 'total': 372},
    ];

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Monthly ATS Score Trajectory',
                      style: AppTextStyles.h3(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Continuous improvement in candidate resume readability.',
                      style: AppTextStyles.bodySmall(),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+5.4 pts gain',
                    style: AppTextStyles.badge(color: AppColors.success),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: monthlyData.map((d) {
                final avg = d['avg'] as double;
                final height = (avg - 70) * 12; // Dynamic height calculation

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      avg.toStringAsFixed(1),
                      style: AppTextStyles.badge(color: AppColors.primary),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 36,
                      height: height.clamp(40.0, 160.0),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [AppColors.primaryLight, AppColors.primary],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      d['month'] as String,
                      style: AppTextStyles.titleSmall(),
                    ),
                    Text(
                      '${d['total']} docs',
                      style: AppTextStyles.bodySmall(),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
