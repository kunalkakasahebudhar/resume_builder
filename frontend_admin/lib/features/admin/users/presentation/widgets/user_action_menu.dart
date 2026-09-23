import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/confirm_dialog.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';

class UserActionMenu extends ConsumerWidget {
  final AdminUser user;
  final Function(String, String) onStatusChange;
  final Function(String) onDelete;

  const UserActionMenu({
    super.key,
    required this.user,
    required this.onStatusChange,
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
        if (value == 'view') {
          context.go('/admin/users/${user.id}');
        } else if (value == 'impersonate') {
          final confirmed = await ConfirmDialog.show(
            context: context,
            title: 'Impersonate User Session',
            message:
                'Generate a time-limited shadow session for "${user.name}" (${user.email}) to inspect their resume workspace exactly as they see it?',
            confirmText: 'Begin Impersonation',
            type: ConfirmDialogType.warning,
          );
          if (confirmed == true) {
            ref.read(auditLogsProvider.notifier).log(
                  action: AuditAction.userImpersonated,
                  actor: adminName,
                  actorEmail: admin?.email ?? 'admin@resumeforge.com',
                  actorRole: admin?.role.name ?? 'super_admin',
                  targetId: user.id,
                  targetType: 'UserAccount',
                  description:
                      'Started impersonation session for user ${user.email}',
                  metadata: {'userId': user.id, 'userEmail': user.email},
                );

            if (context.mounted) {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.security, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Text('Impersonation Session Active',
                          style: AppTextStyles.h3()),
                    ],
                  ),
                  content: Text(
                    'Shadow session token generated for ${user.email}. User environment opened in preview mode.',
                    style: AppTextStyles.bodyMedium(),
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
          }
        } else if (value == 'reset_password') {
          final confirmed = await ConfirmDialog.show(
            context: context,
            title: 'Send Password Reset Email?',
            message:
                'Dispatch a secure password reset link to ${user.email}. Existing active sessions will remain intact.',
            confirmText: 'Send Reset Link',
            type: ConfirmDialogType.info,
          );
          if (confirmed == true) {
            ref.read(auditLogsProvider.notifier).log(
                  action: AuditAction.userPasswordReset,
                  actor: adminName,
                  actorEmail: admin?.email ?? 'admin@resumeforge.com',
                  actorRole: admin?.role.name ?? 'super_admin',
                  targetId: user.id,
                  targetType: 'UserAccount',
                  description:
                      'Triggered password reset email for ${user.email}',
                  metadata: {'userId': user.id},
                );

            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset dispatched to ${user.email}'),
                  backgroundColor: AppColors.success,
                ),
              );
            }
          }
        } else if (value == 'activate') {
          onStatusChange(user.id, 'Active');
          ref.read(auditLogsProvider.notifier).log(
                action: AuditAction.userUnbanned,
                actor: adminName,
                actorEmail: admin?.email ?? 'admin@resumeforge.com',
                actorRole: admin?.role.name ?? 'super_admin',
                targetId: user.id,
                targetType: 'UserAccount',
                description: 'Activated user account for ${user.email}',
                metadata: {'userId': user.id},
              );
        } else if (value == 'deactivate') {
          final banReasonCtrl = TextEditingController();
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Suspend / Ban User Account'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suspending ${user.name} (${user.email}) will immediately terminate all active web sessions and prevent login.',
                    style: AppTextStyles.bodyMedium(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: banReasonCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Reason for Suspension / Ban',
                      hintText: 'e.g. Terms violation, spam reports, billing fraud',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                      backgroundColor: AppColors.warning),
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Suspend User'),
                ),
              ],
            ),
          );

          if (confirm == true) {
            onStatusChange(user.id, 'Inactive');
            ref.read(auditLogsProvider.notifier).log(
                  action: AuditAction.userBanned,
                  actor: adminName,
                  actorEmail: admin?.email ?? 'admin@resumeforge.com',
                  actorRole: admin?.role.name ?? 'super_admin',
                  targetId: user.id,
                  targetType: 'UserAccount',
                  description:
                      'Suspended user ${user.email}. Reason: ${banReasonCtrl.text.trim().isEmpty ? "Policy violation" : banReasonCtrl.text.trim()}',
                  metadata: {
                    'userId': user.id,
                    'reason': banReasonCtrl.text.trim()
                  },
                );
          }
          banReasonCtrl.dispose();
        } else if (value == 'delete') {
          final confirm = await ConfirmDialog.show(
            context: context,
            title: 'GDPR Hard Delete User?',
            message:
                'Permanently purge ${user.name} (${user.email}) and all ${user.resumesCount} associated resumes from the primary database. This action is irreversible.',
            confirmText: 'Purge User & Data',
            type: ConfirmDialogType.danger,
          );
          if (confirm == true) {
            onDelete(user.id);
            ref.read(auditLogsProvider.notifier).log(
                  action: AuditAction.userDeleted,
                  actor: adminName,
                  actorEmail: admin?.email ?? 'admin@resumeforge.com',
                  actorRole: admin?.role.name ?? 'super_admin',
                  targetId: user.id,
                  targetType: 'UserAccount',
                  description:
                      'GDPR permanent purge executed for user ${user.email}',
                  metadata: {'userId': user.id, 'userEmail': user.email},
                );
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(
                Icons.visibility_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              SizedBox(width: 8),
              Text('View Details & Resumes'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'impersonate',
          child: Row(
            children: [
              Icon(
                Icons.switch_account_outlined,
                size: 18,
                color: Color(0xFF0284C7),
              ),
              SizedBox(width: 8),
              Text('Impersonate User View'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'reset_password',
          child: Row(
            children: [
              Icon(
                Icons.lock_reset_rounded,
                size: 18,
                color: Color(0xFF64748B),
              ),
              SizedBox(width: 8),
              Text('Send Password Reset Link'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        if (user.status != 'Active')
          const PopupMenuItem(
            value: 'activate',
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: AppColors.success,
                ),
                SizedBox(width: 8),
                Text('Activate User Account'),
              ],
            ),
          ),
        if (user.status == 'Active')
          const PopupMenuItem(
            value: 'deactivate',
            child: Row(
              children: [
                Icon(Icons.block_outlined, size: 18, color: AppColors.warning),
                SizedBox(width: 8),
                Text('Suspend / Ban User'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_forever_rounded,
                size: 18,
                color: AppColors.error,
              ),
              SizedBox(width: 8),
              Text('GDPR Purge Account',
                  style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }
}
