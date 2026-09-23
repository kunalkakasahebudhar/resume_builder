import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/date_utils.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/core/widgets/app_error.dart';
import 'package:frontend_admin/core/widgets/app_loader.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/users/presentation/providers/admin_users_provider.dart';
import 'package:frontend_admin/features/admin/users/presentation/widgets/user_status_badge.dart';

class UserDetailsPage extends ConsumerStatefulWidget {
  final String userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  ConsumerState<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends ConsumerState<UserDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUsersProvider.notifier).loadUserDetails(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersState = ref.watch(adminUsersProvider);
    final user = usersState.selectedUser;

    return AdminLayout(
      title: 'User Profile Details',
      currentPath: '/admin/users',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back navigation button
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: () => context.go('/admin/users'),
                ),
                const SizedBox(width: 8),
                Text('Back to Users', style: AppTextStyles.titleMedium()),
              ],
            ),
            const SizedBox(height: 16),

            if (usersState.isActionLoading && user == null)
              const Expanded(
                child: AppLoader(message: 'Loading user details...'),
              )
            else if (user == null)
              Expanded(
                child: AppError(
                  message: 'User not found.',
                  onRetry: () => ref
                      .read(adminUsersProvider.notifier)
                      .loadUserDetails(widget.userId),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Hero Card
                      Card(
                        elevation: 0,
                        color: AppColors.card(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 700;
                              return Flex(
                                direction:
                                    isWide ? Axis.horizontal : Axis.vertical,
                                crossAxisAlignment: isWide
                                    ? CrossAxisAlignment.center
                                    : CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 36,
                                        backgroundColor:
                                            AppColors.primaryContainer,
                                        child: Text(
                                          user.name.isNotEmpty
                                              ? user.name[0].toUpperCase()
                                              : 'U',
                                          style: AppTextStyles.h1(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    user.name,
                                                    style: AppTextStyles.h2(),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                UserStatusBadge(
                                                    status: user.status),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              user.email,
                                              style: AppTextStyles.bodyMedium(
                                                color: AppColors.textSecondary(
                                                    context),
                                              ),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Member since ${AppDateUtils.formatDate(user.createdAt)} • Last active ${AppDateUtils.timeAgo(user.lastActive)}',
                                              style: AppTextStyles.bodySmall(
                                                color: AppColors.textSecondary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      width: isWide ? 16 : 0,
                                      height: isWide ? 0 : 16),
                                  // Action Buttons
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (user.status != 'Active')
                                        AppButton(
                                          text: 'Activate Account',
                                          variant: AppButtonVariant.primary,
                                          onPressed: () async {
                                            await ref
                                                .read(adminUsersProvider
                                                    .notifier)
                                                .updateUserStatus(
                                                  user.id,
                                                  'Active',
                                                );
                                          },
                                        ),
                                      if (user.status == 'Active')
                                        AppButton(
                                          text: 'Deactivate',
                                          variant: AppButtonVariant.outline,
                                          onPressed: () async {
                                            final confirm = await AppDialog
                                                .showConfirmation(
                                              context: context,
                                              title: 'Deactivate User',
                                              message:
                                                  'Are you sure you want to deactivate ${user.name}?',
                                              confirmText: 'Deactivate',
                                              isDanger: true,
                                            );
                                            if (confirm == true) {
                                              await ref
                                                  .read(adminUsersProvider
                                                      .notifier)
                                                  .updateUserStatus(
                                                    user.id,
                                                    'Inactive',
                                                  );
                                            }
                                          },
                                        ),
                                      AppButton(
                                        text: 'Delete User',
                                        variant: AppButtonVariant.danger,
                                        onPressed: () async {
                                          final confirm = await AppDialog
                                              .showConfirmation(
                                            context: context,
                                            title: 'Delete User Permanently',
                                            message:
                                                'Are you sure you want to delete ${user.name}? All created resumes will be permanently removed.',
                                            confirmText: 'Delete',
                                            isDanger: true,
                                          );
                                          if (confirm == true) {
                                            final success = await ref
                                                .read(adminUsersProvider
                                                    .notifier)
                                                .deleteUser(user.id);
                                            if (success && context.mounted) {
                                              context.go('/admin/users');
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User Details Grid
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 750;
                          return Flex(
                            direction: isWide ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Contact & Social Details
                              Expanded(
                                flex: isWide ? 3 : 0,
                                child: Card(
                                  elevation: 0,
                                  color: AppColors.card(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppColors.border(context),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Contact & Profile Links',
                                          style: AppTextStyles.h3(),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildDetailRow(
                                          Icons.phone_outlined,
                                          'Phone',
                                          user.phone ?? 'Not provided',
                                        ),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                          Icons.link_rounded,
                                          'LinkedIn',
                                          user.linkedIn ?? 'Not linked',
                                        ),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                          Icons.code_rounded,
                                          'GitHub',
                                          user.github ?? 'Not linked',
                                        ),
                                        const Divider(height: 24),
                                        _buildDetailRow(
                                          Icons.language_rounded,
                                          'Portfolio',
                                          user.portfolio ?? 'Not provided',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width: isWide ? 20 : 0,
                                  height: isWide ? 0 : 20),

                              // Resume Stats
                              Expanded(
                                flex: isWide ? 2 : 0,
                                child: Card(
                                  elevation: 0,
                                  color: AppColors.card(context),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppColors.border(context),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Resume Activity',
                                          style: AppTextStyles.h3(),
                                        ),
                                        const SizedBox(height: 20),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryContainer,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.description_outlined,
                                                color: AppColors.primary,
                                                size: 28,
                                              ),
                                              const SizedBox(width: 14),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${user.resumesCount} Resumes Created',
                                                    style: AppTextStyles
                                                        .titleMedium(
                                                      color:
                                                          AppColors.primaryDark,
                                                    ),
                                                  ),
                                                  Text(
                                                    'ATS-ready documents',
                                                    style: AppTextStyles
                                                        .bodySmall(),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        AppButton(
                                          text: 'View User Resumes',
                                          variant: AppButtonVariant.outline,
                                          width: double.infinity,
                                          onPressed: () =>
                                              context.go('/admin/resumes'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary(context)),
        const SizedBox(width: 12),
        Text(label, style: AppTextStyles.label()),
        const Spacer(),
        Text(
          value,
          style: AppTextStyles.bodyMedium(),
        ),
      ],
    );
  }
}
