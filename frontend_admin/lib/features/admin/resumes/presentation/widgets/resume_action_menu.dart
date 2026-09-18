import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';

class ResumeActionMenu extends StatelessWidget {
  final AdminResume resume;
  final Function(String) onDelete;

  const ResumeActionMenu({
    super.key,
    required this.resume,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: AppColors.textSecondaryLight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == 'preview') {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Row(
                children: [
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(resume.resumeName, style: AppTextStyles.h3()),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Owner: ${resume.userName} (${resume.userEmail})',
                    style: AppTextStyles.bodyMedium(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Template: ${resume.templateName}',
                    style: AppTextStyles.bodyMedium(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Target Role: ${resume.targetRole}',
                    style: AppTextStyles.bodyMedium(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ATS Readability Score: ${resume.atsScore} / 100',
                    style: AppTextStyles.titleMedium(color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: AppColors.textMutedLight,
                          ),
                          SizedBox(height: 8),
                          Text('ATS-Formatted Resume Preview Document'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        } else if (value == 'analyze') {
          context.go('/admin/analytics');
        } else if (value == 'delete') {
          final confirm = await AppDialog.showConfirmation(
            context: context,
            title: 'Delete Resume',
            message:
                'Are you sure you want to permanently delete "${resume.resumeName}"? This document cannot be recovered.',
            confirmText: 'Delete Resume',
            isDanger: true,
          );
          if (confirm == true) {
            onDelete(resume.id);
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(
                Icons.remove_red_eye_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text('Preview Resume'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'analyze',
          child: Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 18,
                color: AppColors.secondary,
              ),
              SizedBox(width: 8),
              Text('Analyze ATS Score'),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.error,
              ),
              SizedBox(width: 8),
              Text('Delete Resume', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }
}
