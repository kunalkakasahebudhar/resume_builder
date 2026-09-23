import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_badge.dart';
import 'package:frontend_admin/core/widgets/app_card.dart';
import 'package:frontend_admin/features/admin/ai_ops/presentation/providers/ai_ops_provider.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import 'package:frontend_admin/features/admin/billing/presentation/providers/billing_admin_provider.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_stat_card.dart';
import 'package:frontend_admin/features/admin/moderation/presentation/providers/moderation_provider.dart';
import 'package:frontend_admin/features/admin/users/presentation/providers/admin_users_provider.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(adminAuthProvider);
    final currentAdmin = authState.admin;
    final adminName = currentAdmin?.name ?? 'Admin';
    final roleName = currentAdmin?.role.displayName ?? 'Super Admin';

    final usersState = ref.watch(adminUsersProvider);
    final billingState = ref.watch(billingAdminProvider);
    final modState = ref.watch(moderationProvider);
    final aiState = ref.watch(aiOpsProvider);
    final auditState = ref.watch(auditLogsProvider);

    final stats = [
      {
        'title': 'Monthly Recurring Rev',
        'value': '₹${NumberFormat('#,##,###').format(billingState.mrr.toInt())}',
        'subtitle': '498 active Pro subscribers',
        'trend': '+14.2%',
        'icon': Icons.currency_rupee_rounded,
        'iconColor': AppColors.primary,
        'iconBgColor': AppColors.primaryContainer,
      },
      {
        'title': 'Total Job Seekers',
        'value': '${usersState.users.length}',
        'subtitle': '86.8% active retention',
        'trend': '+12.4%',
        'icon': Icons.people_outline_rounded,
        'iconColor': AppColors.success,
        'iconBgColor': AppColors.successLight,
      },
      {
        'title': 'AI Invocations (24h)',
        'value': NumberFormat('#,##,###').format(aiState.totalCalls24h),
        'subtitle': '${aiState.avgLatencyTotal.toInt()}ms avg latency',
        'trend': '+18.5%',
        'icon': Icons.auto_awesome_rounded,
        'iconColor': const Color(0xFF0284C7),
        'iconBgColor': const Color(0xFFE0F2FE),
      },
      {
        'title': 'Pending Moderation',
        'value': '${modState.pendingCount}',
        'subtitle': 'Shared resume URLs reported',
        'trend': modState.pendingCount > 0 ? 'Action Req' : 'Clear',
        'icon': Icons.shield_outlined,
        'iconColor': modState.pendingCount > 0
            ? AppColors.warning
            : AppColors.success,
        'iconBgColor': modState.pendingCount > 0
            ? AppColors.warningLight
            : AppColors.successLight,
      },
      {
        'title': 'Average ATS Score',
        'value': '84.6 / 100',
        'subtitle': 'PRD transparent rubric',
        'trend': '+3.2%',
        'icon': Icons.analytics_outlined,
        'iconColor': AppColors.warning,
        'iconBgColor': AppColors.warningLight,
      },
      {
        'title': 'Global AI Gateway',
        'value': aiState.globalAiEnabled ? 'ONLINE' : 'PAUSED',
        'subtitle': aiState.globalAiEnabled
            ? '0.14% error rate'
            : 'Emergency Kill-Switch',
        'trend': aiState.globalAiEnabled ? 'Healthy' : 'Stopped',
        'icon': Icons.bolt_rounded,
        'iconColor':
            aiState.globalAiEnabled ? AppColors.success : AppColors.error,
        'iconBgColor': aiState.globalAiEnabled
            ? AppColors.successLight
            : AppColors.errorLight,
      },
    ];

    return AdminLayout(
      title: 'Command Center Dashboard',
      currentPath: '/admin/dashboard',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Card with Quick Action shortcuts
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 750;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isWide ? 1 : 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 12,
                              runSpacing: 8,
                              children: [
                                Text(
                                  'Welcome back, $adminName',
                                  style: AppTextStyles.h1(color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: AppColors.primaryLight
                                            .withValues(alpha: 0.5)),
                                  ),
                                  child: Text(
                                    roleName.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ResumeForge Operations Hub • Strict Superset Management across all 14 Product Domains',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.auto_awesome, size: 18),
                            label: const Text('AI Prompt Studio'),
                            onPressed: () => context.go('/admin/ai-ops'),
                          ),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: const BorderSide(color: Color(0xFF475569)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            icon: const Icon(Icons.shield_outlined, size: 18),
                            label: Text('Moderation (${modState.pendingCount})'),
                            onPressed: () => context.go('/admin/moderation'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Stat Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount = 3;
                if (constraints.maxWidth < 640) {
                  crossAxisCount = 1;
                } else if (constraints.maxWidth < 1100) {
                  crossAxisCount = 2;
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 140,
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final item = stats[index];
                    return AdminStatCard(
                      title: item['title'] as String,
                      value: item['value'] as String,
                      subtitle: item['subtitle'] as String?,
                      trend: item['trend'] as String?,
                      icon: item['icon'] as IconData,
                      iconColor: item['iconColor'] as Color?,
                      iconBgColor: item['iconBgColor'] as Color?,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Domain Health & Moderation Quick Actions
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 900;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Moderation Queue Spotlight
                    Expanded(
                      flex: isWide ? 6 : 0,
                      child: AppCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shield_rounded,
                                        color: AppColors.warning, size: 22),
                                    const SizedBox(width: 8),
                                    Text('Reported Content Moderation',
                                        style: AppTextStyles.h3()),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.go('/admin/moderation'),
                                  child: const Text('View All Queue →'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (modState.items.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text('No flagged content in queue.'),
                              )
                            else
                              ...modState.items.take(3).map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface(context),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: AppColors.border(context)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.resumeTitle,
                                              style: AppTextStyles.bodyMedium(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${item.userName} • Reason: ${item.reportReason}',
                                              style: AppTextStyles.caption(
                                                  color: AppColors
                                                      .textSecondaryLight),
                                            ),
                                          ],
                                        ),
                                      ),
                                      _buildModBadge(item.status),
                                    ],
                                  ),
                                );
                              }),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 20),

                    // Right: Live Security Audit Trail Stream
                    Expanded(
                      flex: isWide ? 5 : 0,
                      child: AppCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.history_edu_rounded,
                                        color: AppColors.primary, size: 22),
                                    const SizedBox(width: 8),
                                    Text('Live Audit Trail',
                                        style: AppTextStyles.h3()),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () =>
                                      context.go('/admin/audit-logs'),
                                  child: const Text('Full Audit Log →'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ...auditState.logs.take(4).map((log) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          top: 6, right: 10),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            log.description,
                                            style: AppTextStyles.bodySmall(
                                                fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${log.actor} • ${DateFormat('HH:mm').format(log.timestamp)}',
                                            style: AppTextStyles.caption(
                                                color: AppColors
                                                    .textSecondaryLight),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
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
    );
  }

  Widget _buildModBadge(String status) {
    switch (status) {
      case 'pending':
        return const AppBadge(
            text: 'Pending Review', variant: BadgeVariant.warning);
      case 'quarantined':
        return const AppBadge(
            text: 'Quarantined', variant: BadgeVariant.error);
      default:
        return AppBadge(text: status);
    }
  }
}
