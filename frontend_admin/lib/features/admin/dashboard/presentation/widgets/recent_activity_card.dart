import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';

class RecentUsersCard extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const RecentUsersCard({super.key, required this.users});

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
                Text('Recent Users', style: AppTextStyles.h3()),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${users.length} new',
                    style: AppTextStyles.badge(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppColors.backgroundLight,
                ),
                horizontalMargin: 12,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Joined')),
                ],
                rows: users.map((user) {
                  final isActive = user['status'] == 'Active';
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.primaryContainer,
                              child: Text(
                                (user['name'] as String)[0].toUpperCase(),
                                style: AppTextStyles.badge(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              user['name'] as String,
                              style: AppTextStyles.titleSmall(),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          user['email'] as String,
                          style: AppTextStyles.bodyMedium(),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.successLight
                                : AppColors.errorLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['status'] as String,
                            style: AppTextStyles.badge(
                              color: isActive
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          user['joined'] as String,
                          style: AppTextStyles.bodySmall(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentResumesCard extends StatelessWidget {
  final List<Map<String, dynamic>> resumes;

  const RecentResumesCard({super.key, required this.resumes});

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
                Text('Recent Resumes', style: AppTextStyles.h3()),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Text(
                    '${resumes.length} processed',
                    style: AppTextStyles.badge(
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppColors.backgroundLight,
                ),
                horizontalMargin: 12,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Resume')),
                  DataColumn(label: Text('User')),
                  DataColumn(label: Text('Template')),
                  DataColumn(label: Text('ATS Score')),
                  DataColumn(label: Text('Updated')),
                ],
                rows: resumes.map((res) {
                  final score = res['atsScore'] as int;
                  Color scoreColor = AppColors.success;
                  Color scoreBg = AppColors.successLight;
                  if (score < 60) {
                    scoreColor = AppColors.error;
                    scoreBg = AppColors.errorLight;
                  } else if (score < 80) {
                    scoreColor = AppColors.warning;
                    scoreBg = AppColors.warningLight;
                  }

                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.picture_as_pdf_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              res['resume'] as String,
                              style: AppTextStyles.titleSmall(),
                            ),
                          ],
                        ),
                      ),
                      DataCell(
                        Text(
                          res['user'] as String,
                          style: AppTextStyles.bodyMedium(),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            res['template'] as String,
                            style: AppTextStyles.badge(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: scoreBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$score / 100',
                            style: AppTextStyles.badge(color: scoreColor),
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          res['updated'] as String,
                          style: AppTextStyles.bodySmall(),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AtsOverviewCard extends StatelessWidget {
  final double averageScore;
  final int highScore;
  final int mediumScore;
  final int lowScore;

  const AtsOverviewCard({
    super.key,
    required this.averageScore,
    required this.highScore,
    required this.mediumScore,
    required this.lowScore,
  });

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
            Text('ATS Health Overview', style: AppTextStyles.h3()),
            const SizedBox(height: 6),
            Text(
              '100-point transparent ATS score distribution across all resumes.',
              style: AppTextStyles.bodySmall(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Average ATS Score',
                          style: AppTextStyles.label(
                            color: AppColors.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${averageScore.toStringAsFixed(1)} / 100',
                          style: AppTextStyles.h1(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildTierRow(
                        'High (80-100)',
                        highScore,
                        AppColors.success,
                      ),
                      const SizedBox(height: 8),
                      _buildTierRow(
                        'Medium (60-79)',
                        mediumScore,
                        AppColors.warning,
                      ),
                      const SizedBox(height: 8),
                      _buildTierRow('Low (0-59)', lowScore, AppColors.error),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierRow(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium())),
        Text('$count resumes', style: AppTextStyles.titleSmall(color: color)),
      ],
    );
  }
}
