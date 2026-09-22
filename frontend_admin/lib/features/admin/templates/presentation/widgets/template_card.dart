import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/date_utils.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/features/admin/templates/domain/entities/template.dart';
import 'template_preview.dart';
import 'template_status_badge.dart';

class TemplateCard extends StatelessWidget {
  final Template template;
  final VoidCallback onEdit;
  final VoidCallback onPreview;
  final Function(String, String) onStatusChange;
  final Function(String) onDelete;

  const TemplateCard({
    super.key,
    required this.template,
    required this.onEdit,
    required this.onPreview,
    required this.onStatusChange,
    required this.onDelete,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visual ATS Template Preview
          TemplatePreview(
            category: template.category,
            accentColorHex: template.previewColor,
          ),

          // Content Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        template.name,
                        style: AppTextStyles.h3(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TemplateStatusBadge(status: template.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  template.description,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondaryLight,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${template.usageCount} resumes created',
                      style: AppTextStyles.badge(color: AppColors.primary),
                    ),
                    Text(
                      AppDateUtils.formatDate(template.createdAt),
                      style: AppTextStyles.bodySmall(),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // Card Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Edit',
                        variant: AppButtonVariant.outline,
                        height: 36,
                        onPressed: onEdit,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: AppButton(
                        text: 'Preview',
                        variant: AppButtonVariant.primary,
                        height: 36,
                        onPressed: onPreview,
                      ),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 20,
                        color: AppColors.textSecondaryLight,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onSelected: (val) async {
                        if (val == 'activate') {
                          onStatusChange(template.id, 'Active');
                        } else if (val == 'deactivate') {
                          final confirm = await AppDialog.showConfirmation(
                            context: context,
                            title: 'Deactivate Template',
                            message:
                                'Are you sure you want to deactivate ${template.name}?',
                            confirmText: 'Deactivate',
                            isDanger: true,
                          );
                          if (confirm == true) {
                            onStatusChange(template.id, 'Inactive');
                          }
                        } else if (val == 'delete') {
                          final confirm = await AppDialog.showConfirmation(
                            context: context,
                            title: 'Delete Template',
                            message:
                                'Are you sure you want to delete ${template.name}?',
                            confirmText: 'Delete',
                            isDanger: true,
                          );
                          if (confirm == true) {
                            onDelete(template.id);
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
                        if (template.status != 'Active')
                          const PopupMenuItem(
                            value: 'activate',
                            child: Text('Activate'),
                          ),
                        if (template.status == 'Active')
                          const PopupMenuItem(
                            value: 'deactivate',
                            child: Text('Deactivate'),
                          ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Delete',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
