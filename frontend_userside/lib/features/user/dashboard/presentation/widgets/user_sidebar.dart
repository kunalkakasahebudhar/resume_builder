import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_dialog.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class UserSidebar extends ConsumerWidget {
  final String currentRoute;
  final VoidCallback? onItemTapped;

  const UserSidebar({super.key, required this.currentRoute, this.onItemTapped});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resumeCount = ref.watch(resumesListProvider).resumes.length;

    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline.withValues(
              alpha: isDark ? 0.4 : 0.8,
            ),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo & Branding Header
          InkWell(
            onTap: () => context.go('/dashboard'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF3B82F6), const Color(0xFF6366F1)]
                            : [
                                const Color(0xFF2563EB),
                                const Color(0xFF4F46E5),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF2563EB,
                          ).withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Resume',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Forge',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 1),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'ATS PRO v1.0',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: 0.5,
                                ),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 14),

          // Main Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildSectionLabel(context, 'OVERVIEW'),
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  route: '/dashboard',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.folder_outlined,
                  activeIcon: Icons.folder_rounded,
                  label: 'My Resumes',
                  route: '/resumes',
                  badgeText: resumeCount > 0 ? '$resumeCount' : null,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.add_circle_outline_rounded,
                  activeIcon: Icons.add_circle_rounded,
                  label: 'Create Resume',
                  route: '/resumes/new',
                ),
                const SizedBox(height: 12),
                _buildSectionLabel(context, 'TOOLS & AI'),
                _buildNavItem(
                  context: context,
                  icon: Icons.palette_outlined,
                  activeIcon: Icons.palette_rounded,
                  label: 'Templates',
                  route: '/templates',
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.analytics_outlined,
                  activeIcon: Icons.analytics_rounded,
                  label: 'ATS Analyzer',
                  route: '/ats',
                  badgeText: '100pt',
                  badgeColor: const Color(0xFF10B981),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.visibility_outlined,
                  activeIcon: Icons.visibility_rounded,
                  label: 'Live Preview',
                  route: '/preview',
                ),
                const SizedBox(height: 12),
                _buildSectionLabel(context, 'ACCOUNT'),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                  route: '/profile',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // User info footer & Logout
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildNavItem(
              context: context,
              icon: Icons.logout_rounded,
              activeIcon: Icons.logout_rounded,
              label: 'Logout',
              isDestructive: true,
              onCustomTap: () async {
                final confirmed = await AppDialog.showConfirmation(
                  context: context,
                  title: 'Sign Out',
                  message: 'Are you sure you want to sign out of your account?',
                  confirmText: 'Logout',
                  isDestructive: true,
                );
                if (confirmed == true) {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go('/login');
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 6),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    String? route,
    String? badgeText,
    Color? badgeColor,
    bool isDestructive = false,
    VoidCallback? onCustomTap,
  }) {
    final theme = Theme.of(context);
    final isSelected = route != null && currentRoute == route;
    final isDark = theme.brightness == Brightness.dark;

    final itemColor = isDestructive
        ? theme.colorScheme.error
        : isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.75 : 0.65);

    final bgColor = isSelected
        ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.08)
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            onItemTapped?.call();
            if (onCustomTap != null) {
              onCustomTap();
            } else if (route != null) {
              context.go(route);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 20,
                  color: itemColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: itemColor,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? theme.colorScheme.primary)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: (badgeColor ?? theme.colorScheme.primary)
                            .withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
