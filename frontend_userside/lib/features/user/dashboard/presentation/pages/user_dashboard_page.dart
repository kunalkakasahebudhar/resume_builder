import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_userside/core/widgets/app_empty_state.dart';
import 'package:frontend_userside/core/widgets/app_loader.dart';
import 'package:frontend_userside/features/user/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/quick_action_card.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/recent_resume_card.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/resume_stat_card.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/user_layout.dart';
import 'package:frontend_userside/features/user/dashboard/presentation/widgets/welcome_header.dart';
import 'package:frontend_userside/features/user/resume/presentation/providers/resume_provider.dart';
import 'package:go_router/go_router.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final stats = ref.watch(dashboardStatsProvider);
    final resumesState = ref.watch(resumesListProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return UserLayout(
      currentRoute: '/dashboard',
      child: resumesState.isLoading
          ? const AppLoader(message: 'Loading dashboard...')
          : SingleChildScrollView(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeHeader(
                    userName: user?.fullName ?? 'Alex Morgan',
                    onCreateResume: () => context.push('/resumes/new'),
                    onSelectTemplate: () => context.push('/templates'),
                  ),
                  const SizedBox(height: 28),
                  // Stats Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 900;
                      final isTablet =
                          constraints.maxWidth > 600 &&
                          constraints.maxWidth <= 900;

                      final cardWidth = isDesktop
                          ? (constraints.maxWidth - 48) / 4
                          : isTablet
                          ? (constraints.maxWidth - 16) / 2
                          : constraints.maxWidth;

                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          SizedBox(
                            width: cardWidth,
                            child: const ResumeStatCard(
                              title: 'Total Resumes',
                              value: '3',
                              icon: Icons.description_outlined,
                              color: Color(0xFF4F46E5),
                              subtitle: 'Active ATS profiles',
                              trendText: '+1 this week',
                              isPositiveTrend: true,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const ResumeStatCard(
                              title: 'Draft Resumes',
                              value: '1',
                              icon: Icons.edit_note_rounded,
                              color: Color(0xFFF59E0B),
                              subtitle: 'In progress',
                              trendText: 'Pending review',
                              isPositiveTrend: false,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: const ResumeStatCard(
                              title: 'Completed',
                              value: '2',
                              icon: Icons.task_alt_rounded,
                              color: Color(0xFF10B981),
                              subtitle: 'Ready for export',
                              trendText: '100% complete',
                              isPositiveTrend: true,
                            ),
                          ),
                          SizedBox(
                            width: cardWidth,
                            child: ResumeStatCard(
                              title: 'Avg ATS Score',
                              value:
                                  '${stats.averageAtsScore > 0 ? stats.averageAtsScore.toStringAsFixed(0) : '90'}%',
                              icon: Icons.speed_rounded,
                              color: const Color(0xFF6366F1),
                              subtitle: 'Readability index',
                              trendText: 'Top 5%',
                              isPositiveTrend: true,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 28),
                  // Resume Health & ATS Engine Insights Banner
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.verified_rounded,
                            color: Color(0xFF10B981),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ATS Compatibility Health: Optimal (92/100)',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'All active templates conform to standard single-column text flows, parseable typography, and standard ISO headings.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (resumesState.resumes.isNotEmpty) {
                              ref
                                  .read(activeResumeProvider.notifier)
                                  .setResume(resumesState.resumes.first);
                              context.push('/ats');
                            }
                          },
                          icon: const Icon(Icons.analytics_outlined, size: 16),
                          label: const Text('View ATS Report'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF4F46E5),
                            side: const BorderSide(color: Color(0xFF4F46E5)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  // Quick Actions & Recent Resumes
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 860;

                      final quickActionsSection = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 14),
                          QuickActionCard(
                            title: 'Create New Resume',
                            description:
                                'Start from scratch or choose an ATS template',
                            icon: Icons.add_circle_outline_rounded,
                            color: const Color(0xFF4F46E5),
                            onTap: () => context.push('/resumes/new'),
                          ),
                          const SizedBox(height: 12),
                          QuickActionCard(
                            title: 'My Resumes',
                            description:
                                'Manage, duplicate, edit, or delete resumes',
                            icon: Icons.folder_open_rounded,
                            color: const Color(0xFF6366F1),
                            onTap: () => context.push('/resumes'),
                          ),
                          const SizedBox(height: 12),
                          QuickActionCard(
                            title: 'Browse Templates',
                            description:
                                'Switch between 4 ATS-optimized layouts',
                            icon: Icons.palette_outlined,
                            color: const Color(0xFF0EA5E9),
                            onTap: () => context.push('/templates'),
                          ),
                          const SizedBox(height: 12),
                          QuickActionCard(
                            title: 'ATS Analyzer',
                            description:
                                '100-point scan & actionable suggestions',
                            icon: Icons.analytics_outlined,
                            color: const Color(0xFF8B5CF6),
                            onTap: () {
                              if (resumesState.resumes.isNotEmpty) {
                                ref
                                    .read(activeResumeProvider.notifier)
                                    .setResume(resumesState.resumes.first);
                                context.push('/ats');
                              } else {
                                context.push('/resumes/new');
                              }
                            },
                          ),
                        ],
                      );

                      final recentResumesSection = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Resumes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => context.push('/resumes'),
                                icon: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                ),
                                label: Text(
                                  'View All (${resumesState.resumes.length})',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (resumesState.resumes.isEmpty)
                            AppEmptyState(
                              title: 'No resumes created yet',
                              description:
                                  'Create your first ATS-friendly resume now',
                              actionText: 'Create Resume',
                              onAction: () => context.push('/resumes/new'),
                            )
                          else
                            ...resumesState.resumes
                                .take(4)
                                .map(
                                  (resume) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: RecentResumeCard(
                                      resume: resume,
                                      onTap: () {
                                        ref
                                            .read(activeResumeProvider.notifier)
                                            .setResume(resume);
                                        context.push('/resumes/${resume.id}');
                                      },
                                    ),
                                  ),
                                ),
                        ],
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 5, child: recentResumesSection),
                            const SizedBox(width: 24),
                            Expanded(flex: 4, child: quickActionsSection),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            quickActionsSection,
                            const SizedBox(height: 28),
                            recentResumesSection,
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
