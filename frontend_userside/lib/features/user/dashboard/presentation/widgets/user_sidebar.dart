import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_dialog.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/profile/presentation/providers/subscription_provider.dart';
import 'package:frontend_userside/features/user/profile/presentation/widgets/premium_paywall_dialog.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:frontend_userside/features/user/tools/presentation/widgets/resume_importer_dialog.dart';
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
    final sub = ref.watch(subscriptionProvider);

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
                              sub.isPremium ? 'PRO VIP' : 'ATS FREE v1.0',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontSize: 10,
                                color: sub.isPremium
                                    ? const Color(0xFF6366F1)
                                    : theme.colorScheme.onSurface.withValues(
                                        alpha: 0.5,
                                      ),
                                fontWeight: FontWeight.w700,
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
                _buildNavItem(
                  context: context,
                  icon: Icons.upload_file_rounded,
                  activeIcon: Icons.upload_file_rounded,
                  label: '1-Click Import',
                  badgeText: 'Fast',
                  badgeColor: const Color(0xFF0EA5E9),
                  onCustomTap: () => ResumeImporterDialog.show(context),
                ),
                const SizedBox(height: 12),
                _buildSectionLabel(context, 'TEMPLATES & PREVIEW'),
                _buildNavItem(
                  context: context,
                  icon: Icons.palette_outlined,
                  activeIcon: Icons.palette_rounded,
                  label: 'ATS Templates',
                  route: '/templates',
                  badgeText: '11 Pro',
                  badgeColor: const Color(0xFF2563EB),
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
                _buildSectionLabel(context, 'AI POWER TOOLS'),
                _buildNavItem(
                  context: context,
                  icon: Icons.document_scanner_rounded,
                  activeIcon: Icons.document_scanner_rounded,
                  label: 'JD Keyword Matcher',
                  route: '/jd-matcher',
                  badgeText: 'AI Scan',
                  badgeColor: const Color(0xFF8B5CF6),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.edit_document,
                  activeIcon: Icons.edit_document,
                  label: 'AI Cover Letter',
                  route: '/cover-letter',
                  badgeText: 'Instant',
                  badgeColor: const Color(0xFF06B6D4),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.psychology_rounded,
                  activeIcon: Icons.psychology_rounded,
                  label: 'Interview STAR Prep',
                  route: '/interview-prep',
                  badgeText: 'Q&A AI',
                  badgeColor: const Color(0xFF10B981),
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.currency_rupee_rounded,
                  activeIcon: Icons.currency_rupee_rounded,
                  label: 'Salary Estimator',
                  route: '/salary-estimator',
                  badgeText: '₹ Benchmark',
                  badgeColor: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 12),
                _buildSectionLabel(context, 'ACCOUNT'),
                _buildNavItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile & Plan',
                  route: '/profile',
                ),
              ],
            ),
          ),

          // Quota / Pro Upgrade Sidebar Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: _buildSubscriptionWidget(context, ref, sub, isDark),
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

  Widget _buildSubscriptionWidget(
    BuildContext context,
    WidgetRef ref,
    SubscriptionState sub,
    bool isDark,
  ) {
    if (sub.isPremium) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1E1B4B), Color(0xFF312E81)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFFBBF24).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFBBF24),
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sub.planName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Text(
                    'Unlimited Pro Access',
                    style: TextStyle(
                      color: Color(0xFFCBD5E1),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final usesLeft = sub.freeUsesLeft;
    final isExhausted = usesLeft <= 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? (isExhausted ? const Color(0xFF450A0A) : const Color(0xFF1E293B))
            : (isExhausted ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isExhausted
              ? const Color(0xFFEF4444).withValues(alpha: 0.5)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FREE QUOTA',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: isExhausted
                      ? const Color(0xFFEF4444)
                      : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ),
              Text(
                '$usesLeft / 3 Uses',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isExhausted
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF2563EB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usesLeft / 3,
              minHeight: 4,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isExhausted
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF2563EB),
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => PremiumPaywallDialog.show(context),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bolt_rounded, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'Upgrade to Pro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
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
        ? (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5))
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569));

    final bgColor = isSelected
        ? (isDark ? const Color(0x1F6366F1) : const Color(0x144F46E5))
        : Colors.transparent;

    final borderColor = isSelected
        ? (isDark ? const Color(0x336366F1) : const Color(0x294F46E5))
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            hoverColor: isDark
                ? const Color(0x14FFFFFF)
                : const Color(0x0A0F172A),
            onTap: () {
              onItemTapped?.call();
              if (onCustomTap != null) {
                onCustomTap();
              } else if (route != null) {
                context.go(route);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9.5),
              child: Row(
                children: [
                  if (isSelected)
                    Container(
                      width: 3,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6366F1).withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  Icon(
                    isSelected ? activeIcon : icon,
                    size: 19,
                    color: itemColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: itemColor,
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        letterSpacing: -0.1,
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
                            .withValues(alpha: isDark ? 0.18 : 0.12),
                        borderRadius: BorderRadius.circular(8),
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
                          color: badgeColor ?? (isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
