import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/date_utils.dart';
import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';
import 'resume_action_menu.dart';

class ResumeTable extends StatelessWidget {
  final List<AdminResume> resumes;
  final Function(String) onDelete;

  const ResumeTable({super.key, required this.resumes, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (resumes.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              Icons.description_outlined,
              size: 48,
              color: AppColors.textMutedLight,
            ),
            const SizedBox(height: 12),
            Text('No resumes found', style: AppTextStyles.h3()),
            const SizedBox(height: 4),
            Text(
              'Try adjusting your search criteria or filters.',
              style: AppTextStyles.bodyMedium(),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                AppColors.surface(context),
              ),
              horizontalMargin: 20,
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Resume Document')),
                DataColumn(label: Text('User / Email')),
                DataColumn(label: Text('Template')),
                DataColumn(label: Text('Target Role')),
                DataColumn(label: Text('ATS Score')),
                DataColumn(label: Text('Last Updated')),
                DataColumn(label: Text('Actions')),
              ],
              rows: resumes.map((resume) {
                final score = resume.atsScore;
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
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.picture_as_pdf_outlined,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            resume.resumeName,
                            style: AppTextStyles.titleSmall(),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            resume.userName,
                            style: AppTextStyles.titleSmall(),
                          ),
                          Text(
                            resume.userEmail,
                            style: AppTextStyles.bodySmall(
                              color: AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface(context),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: Text(
                          resume.templateName,
                          style: AppTextStyles.badge(
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        resume.targetRole,
                        style: AppTextStyles.bodyMedium(),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
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
                        AppDateUtils.timeAgo(resume.updatedAt),
                        style: AppTextStyles.bodySmall(),
                      ),
                    ),
                    DataCell(
                      ResumeActionMenu(resume: resume, onDelete: onDelete),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
