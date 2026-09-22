import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/app/constants/app_constants.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_top_bar.dart';
import 'package:go_router/go_router.dart';

class LandingNavbar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onFeaturesClick;
  final VoidCallback? onAiSuiteClick;
  final VoidCallback? onTemplatesClick;
  final VoidCallback? onHowItWorksClick;
  final VoidCallback? onFaqClick;
  final VoidCallback? onOpenDrawer;

  const LandingNavbar({
    super.key,
    this.onFeaturesClick,
    this.onAiSuiteClick,
    this.onTemplatesClick,
    this.onHowItWorksClick,
    this.onFaqClick,
    this.onOpenDrawer,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0B0F19).withValues(alpha: 0.92)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            children: [
              // Brand Logo
              InkWell(
                onTap: () => context.go('/'),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4F46E5).withValues(alpha: 0.15),
                              const Color(0xFF7C3AED).withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Text(
                          'ATS 2.0',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6366F1),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Desktop Navigation Links
              LayoutBuilder(
                builder: (context, constraints) {
                  return MediaQuery.of(context).size.width > 920
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _NavLink(
                              label: 'Resume Builder',
                              onTap: onFeaturesClick,
                              isDark: isDark,
                            ),
                            _NavLink(
                              label: 'AI Career Suite',
                              badge: 'PRO',
                              onTap: onAiSuiteClick,
                              isDark: isDark,
                            ),
                            _NavLink(
                              label: 'Templates',
                              onTap: onTemplatesClick,
                              isDark: isDark,
                            ),
                            _NavLink(
                              label: 'How It Works',
                              onTap: onHowItWorksClick,
                              isDark: isDark,
                            ),
                            _NavLink(
                              label: 'FAQ',
                              onTap: onFaqClick,
                              isDark: isDark,
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                },
              ),

              const SizedBox(width: 16),

              // Theme Switcher
              IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  size: 20,
                  color: isDark
                      ? const Color(0xFFFBBF24)
                      : const Color(0xFF475569),
                ),
                tooltip: themeMode == ThemeMode.dark
                    ? 'Switch to Light Mode'
                    : 'Switch to Dark Mode',
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
                style: IconButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Auth State Buttons
              if (authState.isAuthenticated) ...[
                ElevatedButton.icon(
                  onPressed: () => context.go('/dashboard'),
                  icon: const Icon(Icons.dashboard_rounded, size: 16),
                  label: const Text('Go to Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ] else ...[
                if (MediaQuery.of(context).size.width > 600)
                  TextButton(
                    onPressed: () => context.push('/login'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Sign In'),
                  ),
                const SizedBox(width: 6),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push('/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Get Started Free'),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward_rounded, size: 15),
                      ],
                    ),
                  ),
                ),
              ],

              // Mobile Menu Drawer Button
              if (MediaQuery.of(context).size.width <= 920) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: onOpenDrawer,
                  tooltip: 'Menu',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final String? badge;
  final VoidCallback? onTap;
  final bool isDark;

  const _NavLink({
    required this.label,
    this.badge,
    this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFF4F46E5).withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
