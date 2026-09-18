import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';

class UserActionMenu extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
        } else if (value == 'activate') {
          onStatusChange(user.id, 'Active');
        } else if (value == 'deactivate') {
          final confirm = await AppDialog.showConfirmation(
            context: context,
            title: 'Deactivate User',
            message:
                'Are you sure you want to deactivate ${user.name}? They will not be able to log in.',
            confirmText: 'Deactivate',
            isDanger: true,
          );
          if (confirm == true) {
            onStatusChange(user.id, 'Inactive');
          }
        } else if (value == 'delete') {
          final confirm = await AppDialog.showConfirmation(
            context: context,
            title: 'Delete User',
            message:
                'Are you sure you want to permanently delete user ${user.name} and all their resumes? This action cannot be undone.',
            confirmText: 'Delete Permanently',
            isDanger: true,
          );
          if (confirm == true) {
            onDelete(user.id);
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
              Text('View Details'),
            ],
          ),
        ),
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
                Text('Activate User'),
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
                Text('Deactivate User'),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.error,
              ),
              SizedBox(width: 8),
              Text('Delete User', style: TextStyle(color: AppColors.error)),
            ],
          ),
        ),
      ],
    );
  }
}
