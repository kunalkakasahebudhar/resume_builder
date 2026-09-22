import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_dialog.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';

class AdminSidebar extends ConsumerWidget {
  final String currentPath;
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  const AdminSidebar({
    super.key,
    required this.currentPath,
    this.isCollapsed = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navItems = [
      _NavItem(
        title: 'Dashboard',
        icon: Icons.grid_view_rounded,
        route: '/admin/dashboard',
      ),
      _NavItem(
        title: 'Users',
        icon: Icons.people_alt_outlined,
        route: '/admin/users',
      ),
      _NavItem(
        title: 'Resumes',
        icon: Icons.description_outlined,
        route: '/admin/resumes',
      ),
      _NavItem(
        title: 'Templates',
        icon: Icons.dashboard_customize_outlined,
        route: '/admin/templates',
      ),
      _NavItem(
        title: 'ATS Analytics',
        icon: Icons.analytics_outlined,
        route: '/admin/analytics',
      ),
      _NavItem(
        title: 'Profile',
        icon: Icons.person_outline_rounded,
        route: '/admin/profile',
      ),
    ];

    return Container(
      width: isCollapsed ? 76 : 240,
      color: AppColors.sidebarBackground,
      child: Column(
        children: [
          // Logo & Header
          Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ResumeForge',
                          style: AppTextStyles.titleMedium(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Admin Panel',
                          style: AppTextStyles.bodySmall(
                            color: AppColors.sidebarText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Navigation Links
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              children: [
                for (final item in navItems)
                  _buildNavTile(
                    context,
                    item: item,
                    isActive: currentPath.startsWith(item.route),
                    isCollapsed: isCollapsed,
                  ),
              ],
            ),
          ),

          // Logout Button
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFF1E293B), width: 1),
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () async {
                final confirmed = await AppDialog.showConfirmation(
                  context: context,
                  title: 'Confirm Logout',
                  message:
                      'Are you sure you want to sign out from the Admin Portal?',
                  confirmText: 'Sign Out',
                  isDanger: true,
                );
                if (confirmed == true) {
                  await ref.read(adminAuthProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/admin/login');
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: isCollapsed
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                      size: 20,
                    ),
                    if (!isCollapsed) ...[
                      const SizedBox(width: 12),
                      Text(
                        'Logout',
                        style: AppTextStyles.label(color: AppColors.error),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context, {
    required _NavItem item,
    required bool isActive,
    required bool isCollapsed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Tooltip(
        message: isCollapsed ? item.title : '',
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => context.go(item.route),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isActive ? AppColors.sidebarActive : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isActive
                  ? const Border(
                      left: BorderSide(color: AppColors.primaryLight, width: 3),
                    )
                  : null,
            ),
            child: Row(
              mainAxisAlignment: isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isActive
                      ? AppColors.sidebarTextActive
                      : AppColors.sidebarText,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.title,
                      style: AppTextStyles.label(
                        color: isActive
                            ? AppColors.sidebarTextActive
                            : AppColors.sidebarText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String title;
  final IconData icon;
  final String route;

  _NavItem({required this.title, required this.icon, required this.route});
}
