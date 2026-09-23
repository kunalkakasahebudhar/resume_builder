import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/utils/csv_exporter.dart';
import 'package:frontend_admin/core/widgets/app_badge.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_card.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import '../../domain/entities/audit_log.dart';
import '../providers/audit_logs_provider.dart';

class AuditLogsPage extends ConsumerStatefulWidget {
  const AuditLogsPage({super.key});

  @override
  ConsumerState<AuditLogsPage> createState() => _AuditLogsPageState();
}

class _AuditLogsPageState extends ConsumerState<AuditLogsPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(auditLogsProvider);
    final notifier = ref.read(auditLogsProvider.notifier);

    return AdminLayout(
      title: 'Security & Audit Logs',
      currentPath: '/admin/audit-logs',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Metrics Header
            _buildMetricsHeader(state),
            const SizedBox(height: 20),

            // Controls & Filters
            AppCard(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    children: [
                      Expanded(
                        flex: isWide ? 3 : 0,
                        child: AppTextField(
                          controller: _searchCtrl,
                          hintText: 'Search audit trail by admin, action, target, or keywords...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          onChanged: (val) => notifier.setSearchQuery(val),
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterPill('All Actions', 'all',
                                state.actionFilter, (a) => notifier.setActionFilter(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('User Bans & Security', 'user_banned',
                                state.actionFilter, (a) => notifier.setActionFilter(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('AI & Prompt Ops', 'ai_kill_switch',
                                state.actionFilter, (a) => notifier.setActionFilter(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('Moderation', 'content_quarantined',
                                state.actionFilter, (a) => notifier.setActionFilter(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('Rubric Calibrations', 'ats_rubric',
                                state.actionFilter, (a) => notifier.setActionFilter(a)),
                          ],
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                      AppButton(
                        text: 'Export Audit Trail CSV',
                        icon: const Icon(Icons.download_rounded, size: 18),
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          final data = state.filteredLogs.map((l) => {
                                'Log ID': l.id,
                                'Timestamp': DateFormat('yyyy-MM-dd HH:mm:ss')
                                    .format(l.timestamp),
                                'Action': l.action.name,
                                'Actor': l.actor,
                                'Actor Email': l.actorEmail,
                                'Actor Role': l.actorRole,
                                'Target ID': l.targetId,
                                'Target Type': l.targetType,
                                'Description': l.description,
                                'IP Address': l.ipAddress,
                              }).toList();
                          CsvExporter.exportToCsv(
                            fileName:
                                'resumeforge_audit_trail_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.csv',
                            data: data,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Audit logs exported to CSV'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Main Table
            AppCard(
              padding: EdgeInsets.zero,
              child: state.filteredLogs.isEmpty
                  ? _buildEmptyState()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: constraints.maxWidth),
                            child: DataTable(
                              columnSpacing: 20,
                              horizontalMargin: 20,
                              headingRowColor: WidgetStateProperty.all(
                                AppColors.surface(context),
                              ),
                              columns: const [
                                DataColumn(
                                    label: Text('Timestamp',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Action Event',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Actor (Admin)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Target Resource',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Description',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                                DataColumn(
                                    label: Text('Inspector',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600))),
                              ],
                              rows: state.filteredLogs.map((log) {
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('dd MMM yyyy')
                                                .format(log.timestamp),
                                            style: AppTextStyles.bodySmall(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            DateFormat('HH:mm:ss')
                                                .format(log.timestamp),
                                            style: AppTextStyles.caption(
                                                color: AppColors.textSecondary(
                                                    context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(_buildActionBadge(log.action)),
                                    DataCell(
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(log.actor,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(
                                            '${log.actorRole} • ${log.actorEmail}',
                                            style: AppTextStyles.caption(
                                                color: AppColors.textSecondary(
                                                    context)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface(context),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                              color: AppColors.border(context)),
                                        ),
                                        child: Text(
                                          '${log.targetType}:${log.targetId}',
                                          style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width: 320,
                                        child: Text(
                                          log.description,
                                          style: AppTextStyles.bodySmall(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(
                                            Icons.data_object_rounded,
                                            size: 18,
                                            color: AppColors.primary),
                                        tooltip: 'Inspect Metadata Payload',
                                        onPressed: () =>
                                            _showMetadataDialog(context, log),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsHeader(AuditLogsState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final cardWidth = isWide
            ? (constraints.maxWidth - 48) / 4
            : (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricTile(
              title: 'Total Logged Actions',
              value: '${state.logs.length}',
              subtitle: 'Append-only immutable record',
              icon: Icons.history_edu_rounded,
              iconColor: AppColors.primary,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Security / Ban Events',
              value:
                  '${state.logs.where((l) => l.action == AuditAction.userBanned || l.action == AuditAction.userDeleted || l.action == AuditAction.contentQuarantined).length}',
              subtitle: 'High-severity privileged actions',
              icon: Icons.shield_rounded,
              iconColor: AppColors.error,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Active Admin Actors',
              value:
                  '${state.logs.map((l) => l.actorEmail).toSet().length}',
              subtitle: 'Distinct staff members active',
              icon: Icons.admin_panel_settings_rounded,
              iconColor: const Color(0xFF0284C7),
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Audit Compliance',
              value: 'SOC2 / GDPR',
              subtitle: '365 days retention enforced',
              icon: Icons.verified_rounded,
              iconColor: AppColors.success,
              width: cardWidth,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required double width,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.caption(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(icon, color: iconColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: AppTextStyles.h2(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption(color: AppColors.textSecondary(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(
    String label,
    String value,
    String current,
    Function(String) onSelect,
  ) {
    final isSelected = current == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildActionBadge(AuditAction action) {
    switch (action) {
      case AuditAction.userBanned:
      case AuditAction.userDeleted:
      case AuditAction.contentQuarantined:
      case AuditAction.shareLinkRevoked:
      case AuditAction.aiKillSwitchToggled:
        return AppBadge(text: action.name, variant: BadgeVariant.error);
      case AuditAction.userImpersonated:
      case AuditAction.userPasswordReset:
      case AuditAction.maintenanceModeToggled:
      case AuditAction.subscriptionRefunded:
        return AppBadge(text: action.name, variant: BadgeVariant.warning);
      case AuditAction.userUnbanned:
      case AuditAction.contentDismissed:
      case AuditAction.atsRubricCalibrated:
      case AuditAction.promoCodeCreated:
        return AppBadge(text: action.name, variant: BadgeVariant.success);
      default:
        return AppBadge(text: action.name, variant: BadgeVariant.info);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Text(
          'No audit log entries matching criteria.',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary(context)),
        ),
      ),
    );
  }

  void _showMetadataDialog(BuildContext context, AuditLog log) {
    final prettyJson = log.metadata != null
        ? const JsonEncoder.withIndent('  ').convert(log.metadata)
        : '{}';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.code_rounded, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('Audit Payload (${log.id})', style: AppTextStyles.h3()),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Actor: ${log.actor} (${log.actorRole})',
                    style: AppTextStyles.label()),
                Text('IP Address: ${log.ipAddress}',
                    style: AppTextStyles.caption()),
                const Divider(height: 20),
                const Text('Metadata JSON Payload:',
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    prettyJson,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
