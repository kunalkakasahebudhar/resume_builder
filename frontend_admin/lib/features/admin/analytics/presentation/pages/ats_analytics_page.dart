import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/widgets/analytics_stat_card.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/widgets/ats_score_chart.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/widgets/common_warnings_card.dart';
import 'package:frontend_admin/features/admin/analytics/presentation/widgets/score_distribution_chart.dart';

class AtsAnalyticsPage extends StatelessWidget {
  const AtsAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // PRD 100-point transparent category scoring model
    final categories = [
      {
        'title': 'Structure',
        'value': '18.2',
        'max': '20',
        'percent': 0.91,
        'color': AppColors.primary,
      },
      {
        'title': 'Formatting',
        'value': '13.8',
        'max': '15',
        'percent': 0.92,
        'color': AppColors.secondary,
      },
      {
        'title': 'Sections',
        'value': '13.2',
        'max': '15',
        'percent': 0.88,
        'color': AppColors.accent,
      },
      {
        'title': 'Keywords',
        'value': '15.6',
        'max': '20',
        'percent': 0.78,
        'color': AppColors.warning,
      },
      {
        'title': 'Content Quality',
        'value': '12.4',
        'max': '15',
        'percent': 0.82,
        'color': AppColors.info,
      },
      {
        'title': 'Contact Info',
        'value': '4.8',
        'max': '5',
        'percent': 0.96,
        'color': AppColors.success,
      },
      {
        'title': 'Consistency',
        'value': '8.6',
        'max': '10',
        'percent': 0.86,
        'color': AppColors.primaryLight,
      },
    ];

    final warnings = [
      {
        'issue': 'Low Keyword Match for Target Role',
        'impact': '-4.4 pts avg deduction in Keywords section',
        'frequency': '38.2',
      },
      {
        'issue': 'Missing Action Verbs in Bullet Points',
        'impact': '-2.6 pts avg deduction in Content Quality',
        'frequency': '27.5',
      },
      {
        'issue': 'Non-Standard Date Formats',
        'impact': '-1.4 pts avg deduction in Consistency',
        'frequency': '18.1',
      },
      {
        'issue': 'Missing GitHub or Portfolio Link',
        'impact': '-0.5 pts deduction in Contact Info',
        'frequency': '14.3',
      },
    ];

    return AdminLayout(
      title: 'ATS Analytics & Scoring Engine',
      currentPath: '/admin/analytics',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isWide ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Transparent 100-Point ATS Engine',
                                  style: AppTextStyles.h2(),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.successLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'PRD SPEC COMPLIANT',
                                    style: AppTextStyles.badge(
                                      color: AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Evaluates readability, section structure, keyword density, and formatting rules without bias.',
                              style: AppTextStyles.bodyMedium(
                                color: AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: isWide
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Average Overall Score',
                              style: AppTextStyles.bodySmall(
                                color: AppColors.primaryDark,
                              ),
                            ),
                            Text(
                              '84.6 / 100',
                              style: AppTextStyles.h1(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // PRD Category Cards Grid
            Text('Scoring Category Performance', style: AppTextStyles.h3()),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                int cols = 4;
                if (constraints.maxWidth < 700) {
                  cols = 1;
                } else if (constraints.maxWidth < 1100) {
                  cols = 2;
                } else if (constraints.maxWidth < 1400) {
                  cols = 3;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 110,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return AnalyticsStatCard(
                      title: cat['title'] as String,
                      value: cat['value'] as String,
                      maxPoints: cat['max'] as String,
                      percentage: cat['percent'] as double,
                      color: cat['color'] as Color,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Charts Grid
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth >= 1000) {
                  return const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: ScoreDistributionChart()),
                      SizedBox(width: 20),
                      Expanded(child: AtsScoreChart()),
                    ],
                  );
                } else {
                  return const Column(
                    children: [
                      ScoreDistributionChart(),
                      SizedBox(height: 20),
                      AtsScoreChart(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),

            // Common Warnings
            CommonWarningsCard(warnings: warnings),
          ],
        ),
      ),
    );
  }
}
