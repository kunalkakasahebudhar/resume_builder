import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class CommonWarningsCard extends StatelessWidget {
  final List<Map<String, dynamic>> warnings;

  const CommonWarningsCard({super.key, required this.warnings});

  @override
  Widget build(BuildContext context) {
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
                Text('Top ATS Parsing Warnings', style: AppTextStyles.h3()),
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.warning,
                  size: 22,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Most common deductions identified during ATS rule evaluation.',
              style: AppTextStyles.bodySmall(),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: warnings.length,
              separatorBuilder: (context, index) => const Divider(height: 16),
              itemBuilder: (context, index) {
                final w = warnings[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.warningLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            w['issue'] as String,
                            style: AppTextStyles.titleSmall(),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            w['impact'] as String,
                            style: AppTextStyles.bodySmall(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Text(
                        '${w['frequency']}% of resumes',
                        style: AppTextStyles.badge(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
