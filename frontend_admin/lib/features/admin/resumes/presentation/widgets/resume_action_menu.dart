import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/confirm_dialog.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/resumes/domain/entities/admin_resume.dart';
import 'package:go_router/go_router.dart';

class ResumeActionMenu extends ConsumerWidget {
  final AdminResume resume;
  final Function(String) onDelete;

  const ResumeActionMenu({
    super.key,
    required this.resume,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final admin = ref.watch(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.more_vert_rounded,
        size: 20,
        color: AppColors.textSecondaryLight,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == 'preview') {
          _showResumeWireframeDialog(context, resume);
        } else if (value == 'inspect_json') {
          _showJsonInspectorDialog(context, resume);
        } else if (value == 'analyze') {
          context.go('/admin/analytics');
        } else if (value == 'delete') {
          final confirm = await ConfirmDialog.show(
            context: context,
            title: 'Delete Resume Document?',
            message:
                'Permanently delete "${resume.resumeName}" created by ${resume.userEmail}? This will also unpublish any active public share links.',
            confirmText: 'Delete Resume',
            type: ConfirmDialogType.danger,
          );
          if (confirm == true) {
            onDelete(resume.id);
            ref.read(auditLogsProvider.notifier).log(
                  action: AuditAction.resumeDeleted,
                  actor: adminName,
                  actorEmail: admin?.email ?? 'admin@resumeforge.com',
                  actorRole: admin?.role.name ?? 'super_admin',
                  targetId: resume.id,
                  targetType: 'ResumeDocument',
                  description:
                      'Deleted resume "${resume.resumeName}" for user ${resume.userEmail}',
                  metadata: {
                    'resumeId': resume.id,
                    'userEmail': resume.userEmail,
                    'atsScore': resume.atsScore,
                  },
                );
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'preview',
          child: Row(
            children: [
              Icon(Icons.remove_red_eye_outlined,
                  size: 18, color: AppColors.primary),
              SizedBox(width: 8),
              Text('Live Wireframe Preview'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'inspect_json',
          child: Row(
            children: [
              Icon(Icons.data_object_rounded,
                  size: 18, color: Color(0xFF0284C7)),
              SizedBox(width: 8),
              Text('Inspect JSON Payload'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'analyze',
          child: Row(
            children: [
              Icon(Icons.analytics_outlined,
                  size: 18, color: AppColors.secondary),
              SizedBox(width: 8),
              Text('ATS Rubric Breakdown'),
            ],
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded,
                  size: 18, color: AppColors.error),
              SizedBox(width: 8),
              Text('Delete Document', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }

  void _showResumeWireframeDialog(BuildContext context, AdminResume resume) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(resume.resumeName, style: AppTextStyles.h3()),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('Author', '${resume.userName} (${resume.userEmail})'),
                _buildInfoRow('Template', resume.templateName),
                _buildInfoRow('Target Role', resume.targetRole),
                _buildInfoRow('ATS Score', '${resume.atsScore} / 100'),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border(context)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resume.userName.toUpperCase(),
                        style: AppTextStyles.titleMedium(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${resume.targetRole} • ${resume.userEmail}',
                        style: AppTextStyles.bodySmall(color: AppColors.textSecondary(context)),
                      ),
                      const Divider(height: 16),
                      Text(
                        'PROFESSIONAL SUMMARY',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Experienced professional specializing in ${resume.targetRole} with proven track record in high-scale execution.',
                        style: AppTextStyles.bodySmall(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'ATS HIGHLIGHTS & KEYWORDS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: ['Problem Solving', 'Architecture', 'Leadership']
                            .map((k) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface(context),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: AppColors.border(context)),
                                  ),
                                  child: Text(k,
                                      style: TextStyle(fontSize: 10, color: AppColors.textPrimary(context))),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close Preview'),
          ),
        ],
      ),
    );
  }

  void _showJsonInspectorDialog(BuildContext context, AdminResume resume) {
    final rawJson = '''{
  "id": "${resume.id}",
  "title": "${resume.resumeName}",
  "template": "${resume.templateName}",
  "target_role": "${resume.targetRole}",
  "ats_score": ${resume.atsScore},
  "user": {
    "name": "${resume.userName}",
    "email": "${resume.userEmail}"
  },
  "sections": {
    "experience": [
      {
        "role": "${resume.targetRole}",
        "company": "Tech Solutions Inc.",
        "duration": "2022 - Present",
        "bullets": [
          "Engineered distributed services reducing latency by 35%",
          "Spearheaded team of 6 engineers to deliver core deliverables"
        ]
      }
    ],
    "skills": ["TypeScript", "Dart / Flutter", "Cloud Architecture", "System Design"],
    "ats_breakdown": {
      "formatting": 25,
      "keywords": 28,
      "impact": 18,
      "completeness": 15,
      "brevity": 8
    }
  }
}''';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.data_object_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Raw JSON Structure (${resume.id})', style: AppTextStyles.h3()),
          ],
        ),
        content: SizedBox(
          width: 540,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                rawJson,
                style: const TextStyle(
                  color: Color(0xFF38BDF8),
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTextStyles.caption(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall(color: AppColors.textPrimaryLight),
            ),
          ),
        ],
      ),
    );
  }
}
