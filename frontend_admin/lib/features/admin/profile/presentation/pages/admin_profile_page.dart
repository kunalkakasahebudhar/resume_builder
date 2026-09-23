import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/profile/presentation/widgets/admin_profile_form.dart';

class AdminProfilePage extends ConsumerWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(adminAuthProvider);
    final admin = authState.admin;

    return AdminLayout(
      title: 'Admin Profile Settings',
      currentPath: '/admin/profile',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Form Card
                  Card(
                    elevation: 0,
                    color: AppColors.card(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: AdminProfileForm(
                        admin: admin,
                        onSave: (name, phone) {
                          // Profile updated state logic
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Security & Password Card
                  Card(
                    elevation: 0,
                    color: AppColors.card(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Security & Credentials',
                            style: AppTextStyles.h3(),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your password and authentication settings.',
                            style: AppTextStyles.bodySmall(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: AppTextStyles.titleSmall(),
                                  ),
                                  Text(
                                    'Last changed 3 months ago',
                                    style: AppTextStyles.bodySmall(),
                                  ),
                                ],
                              ),
                              AppButton(
                                text: 'Change Password',
                                variant: AppButtonVariant.outline,
                                onPressed: () {
                                  _showChangePasswordDialog(context);
                                },
                              ),
                            ],
                          ),
                          const Divider(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Sign Out',
                                    style: AppTextStyles.titleSmall(
                                      color: AppColors.error,
                                    ),
                                  ),
                                  Text(
                                    'End current session on this device',
                                    style: AppTextStyles.bodySmall(),
                                  ),
                                ],
                              ),
                              AppButton(
                                text: 'Logout',
                                variant: AppButtonVariant.danger,
                                onPressed: () async {
                                  final confirm =
                                      await AppDialog.showConfirmation(
                                        context: context,
                                        title: 'Confirm Logout',
                                        message:
                                            'Are you sure you want to sign out?',
                                        confirmText: 'Sign Out',
                                        isDanger: true,
                                      );
                                  if (confirm == true) {
                                    await ref
                                        .read(adminAuthProvider.notifier)
                                        .logout();
                                    if (context.mounted) {
                                      context.go('/admin/login');
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPass = TextEditingController();
    final newPass = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Change Admin Password', style: AppTextStyles.h3()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              label: 'Current Password',
              controller: currentPass,
              obscureText: true,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'New Password',
              controller: newPass,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          AppButton(
            text: 'Update Password',
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password updated successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
