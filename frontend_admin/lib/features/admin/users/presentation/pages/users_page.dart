import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/core/widgets/app_error.dart';
import 'package:frontend_admin/core/widgets/app_loader.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/users/presentation/providers/admin_users_provider.dart';
import 'package:frontend_admin/features/admin/users/presentation/widgets/user_filter.dart';
import 'package:frontend_admin/features/admin/users/presentation/widgets/user_search_bar.dart';
import 'package:frontend_admin/features/admin/users/presentation/widgets/user_table.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(adminUsersProvider);
    final usersNotifier = ref.read(adminUsersProvider.notifier);

    return AdminLayout(
      title: 'Users Management',
      currentPath: '/admin/users',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Controls Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.borderLight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 700) {
                      return Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: UserSearchBar(
                              onChanged: (q) => usersNotifier.setSearchQuery(q),
                            ),
                          ),
                          const SizedBox(width: 16),
                          UserFilter(
                            selectedStatus: usersState.statusFilter,
                            onStatusChanged: (status) =>
                                usersNotifier.setStatusFilter(status),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          UserSearchBar(
                            onChanged: (q) => usersNotifier.setSearchQuery(q),
                          ),
                          const SizedBox(height: 12),
                          UserFilter(
                            selectedStatus: usersState.statusFilter,
                            onStatusChanged: (status) =>
                                usersNotifier.setStatusFilter(status),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Table Content Area
            Expanded(
              child: Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                child: usersState.isLoading
                    ? const AppLoader(message: 'Loading registered users...')
                    : usersState.errorMessage != null
                    ? AppError(
                        message: usersState.errorMessage!,
                        onRetry: () => usersNotifier.loadUsers(),
                      )
                    : UserTable(
                        users: usersState.users,
                        onStatusChange: (id, status) =>
                            usersNotifier.updateUserStatus(id, status),
                        onDelete: (id) => usersNotifier.deleteUser(id),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
