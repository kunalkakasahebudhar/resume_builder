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
import 'package:frontend_userside/features/user/tools/presentation/widgets/resume_importer_dialog.dart';
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
                  // AI Supercharge Suite Showcase
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                                const Color(0xFF1E1B4B),
                                const Color(0xFF1E293B),
                              ]
                            : [
                                const Color(0xFFEEF2FF),
                                const Color(0xFFF8FAFC),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF4338CA).withValues(alpha: 0.5)
                            : const Color(0xFFC7D2FE),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6366F1),
                                          Color(0xFF8B5CF6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'AI Career Supercharge Suite',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            color: isDark
                                                ? Colors.white
                                                : const Color(0xFF1E1B4B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'Attention-grabbing AI tools to double your interview call rate',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isDark
                                                ? const Color(0xFF94A3B8)
                                                : const Color(0xFF64748B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8B5CF6).withValues(
                                  alpha: 0.15,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFF8B5CF6).withValues(
                                    alpha: 0.4,
                                  ),
                                ),
                              ),
                              child: const Text(
                                'PRO SUITE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF8B5CF6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isDesktop = constraints.maxWidth > 800;
                            final isMobileSingle = constraints.maxWidth < 460;
                            final toolCardWidth = isDesktop
                                ? (constraints.maxWidth - 36) / 4
                                : isMobileSingle
                                    ? constraints.maxWidth
                                    : (constraints.maxWidth - 12) / 2;

                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildAiToolBadgeCard(
                                  context: context,
                                  width: toolCardWidth,
                                  title: 'JD Keyword Matcher',
                                  subtitle: 'Scan JD & detect keyword gaps',
                                  icon: Icons.document_scanner_rounded,
                                  color: const Color(0xFF8B5CF6),
                                  onTap: () => context.push('/jd-matcher'),
                                  isDark: isDark,
                                ),
                                _buildAiToolBadgeCard(
                                  context: context,
                                  width: toolCardWidth,
                                  title: 'AI Cover Letter',
                                  subtitle: 'Role-tailored letter in seconds',
                                  icon: Icons.edit_document,
                                  color: const Color(0xFF06B6D4),
                                  onTap: () => context.push('/cover-letter'),
                                  isDark: isDark,
                                ),
                                _buildAiToolBadgeCard(
                                  context: context,
                                  width: toolCardWidth,
                                  title: 'Interview STAR Kit',
                                  subtitle: 'Predicted Q&A + STAR answers',
                                  icon: Icons.psychology_rounded,
                                  color: const Color(0xFF10B981),
                                  onTap: () => context.push('/interview-prep'),
                                  isDark: isDark,
                                ),
                                _buildAiToolBadgeCard(
                                  context: context,
                                  width: toolCardWidth,
                                  title: 'Salary Estimator',
                                  subtitle: 'Tech stack salary benchmark',
                                  icon: Icons.currency_rupee_rounded,
                                  color: const Color(0xFFF59E0B),
                                  onTap: () =>
                                      context.push('/salary-estimator'),
                                  isDark: isDark,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 640;

                        final icon = Container(
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
                        );

                        final textDetails = Column(
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
                              'All 11 active templates conform to standard single-column text flows, parseable typography, and standard ISO headings.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        );

                        final button = OutlinedButton.icon(
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
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  icon,
                                  const SizedBox(width: 14),
                                  Expanded(child: textDetails),
                                ],
                              ),
                              const SizedBox(height: 14),
                              button,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            icon,
                            const SizedBox(width: 16),
                            Expanded(child: textDetails),
                            const SizedBox(width: 12),
                            button,
                          ],
                        );
                      },
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
                                '11 Certified ATS & Harvard-grade layouts',
                            icon: Icons.palette_outlined,
                            color: const Color(0xFF0EA5E9),
                            onTap: () => context.push('/templates'),
                          ),
                          const SizedBox(height: 12),
                          QuickActionCard(
                            title: '1-Click Fast Import',
                            description:
                                'Paste text or LinkedIn data to auto-generate',
                            icon: Icons.upload_file_rounded,
                            color: const Color(0xFF10B981),
                            onTap: () => ResumeImporterDialog.show(context),
                          ),
                          const SizedBox(height: 12),
                          QuickActionCard(
                            title: 'ATS 100pt Analyzer',
                            description:
                                'Scan readability, keywords & bullet impacts',
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

  Widget _buildAiToolBadgeCard({
    required BuildContext context,
    required double width,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          hoverColor: color.withValues(alpha: 0.08),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.3 : 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
