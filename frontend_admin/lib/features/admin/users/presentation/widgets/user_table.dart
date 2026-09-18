import 'package:flutter/material.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/date_utils.dart';
import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';
import 'user_action_menu.dart';
import 'user_status_badge.dart';

class UserTable extends StatelessWidget {
  final List<AdminUser> users;
  final Function(String, String) onStatusChange;
  final Function(String) onDelete;

  const UserTable({
    super.key,
    required this.users,
    required this.onStatusChange,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        alignment: Alignment.center,
        child: Column(
          children: [
            const Icon(
              Icons.people_outline_rounded,
              size: 48,
              color: AppColors.textMutedLight,
            ),
            const SizedBox(height: 12),
            Text('No users found', style: AppTextStyles.h3()),
            const SizedBox(height: 4),
            Text(
              'Try changing your search query or filter status.',
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
                AppColors.backgroundLight,
              ),
              horizontalMargin: 20,
              columnSpacing: 28,
              columns: const [
                DataColumn(label: Text('User')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Resumes')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Joined')),
                DataColumn(label: Text('Last Active')),
                DataColumn(label: Text('Actions')),
              ],
              rows: users.map((user) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.primaryContainer,
                            child: Text(
                              user.name.isNotEmpty
                                  ? user.name[0].toUpperCase()
                                  : 'U',
                              style: AppTextStyles.titleSmall(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(user.name, style: AppTextStyles.titleSmall()),
                        ],
                      ),
                    ),
                    DataCell(
                      Text(user.email, style: AppTextStyles.bodyMedium()),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${user.resumesCount} resumes',
                          style: AppTextStyles.badge(color: AppColors.primary),
                        ),
                      ),
                    ),
                    DataCell(UserStatusBadge(status: user.status)),
                    DataCell(
                      Text(
                        AppDateUtils.formatDate(user.createdAt),
                        style: AppTextStyles.bodySmall(),
                      ),
                    ),
                    DataCell(
                      Text(
                        AppDateUtils.timeAgo(user.lastActive),
                        style: AppTextStyles.bodySmall(),
                      ),
                    ),
                    DataCell(
                      UserActionMenu(
                        user: user,
                        onStatusChange: onStatusChange,
                        onDelete: onDelete,
                      ),
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
