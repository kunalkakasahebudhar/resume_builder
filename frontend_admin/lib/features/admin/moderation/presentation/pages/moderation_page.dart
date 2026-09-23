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
import 'package:frontend_admin/core/widgets/confirm_dialog.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import '../../domain/entities/moderation_item.dart';
import '../providers/moderation_provider.dart';

class ModerationPage extends ConsumerStatefulWidget {
  const ModerationPage({super.key});

  @override
  ConsumerState<ModerationPage> createState() => _ModerationPageState();
}

class _ModerationPageState extends ConsumerState<ModerationPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(moderationProvider);
    final notifier = ref.read(moderationProvider.notifier);

    return AdminLayout(
      title: 'Shared Content Moderation',
      currentPath: '/admin/moderation',
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Metrics Header
            _buildMetricsHeader(state),
            const SizedBox(height: 20),

            // Filter & Search Controls
            AppCard(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: isWide
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.stretch,
                    children: [
                      // Search box
                      Expanded(
                        flex: isWide ? 3 : 0,
                        child: AppTextField(
                          controller: _searchCtrl,
                          hintText: 'Search by resume, user, slug, or reason...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          onChanged: (val) => notifier.setSearchQuery(val),
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

                      // Status Tabs / Filter Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('All', 'all', state.statusFilter,
                                (s) => notifier.setFilter(s)),
                            const SizedBox(width: 8),
                            _buildFilterChip('Pending', 'pending',
                                state.statusFilter, (s) => notifier.setFilter(s),
                                count: state.pendingCount,
                                color: AppColors.warning),
                            const SizedBox(width: 8),
                            _buildFilterChip('Quarantined', 'quarantined',
                                state.statusFilter, (s) => notifier.setFilter(s),
                                count: state.quarantinedCount,
                                color: AppColors.error),
                            const SizedBox(width: 8),
                            _buildFilterChip('Dismissed', 'dismissed',
                                state.statusFilter, (s) => notifier.setFilter(s)),
                            const SizedBox(width: 8),
                            _buildFilterChip('Unshared', 'unshared',
                                state.statusFilter, (s) => notifier.setFilter(s)),
                          ],
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

                      // Export CSV
                      AppButton(
                        text: 'Export CSV',
                        icon: const Icon(Icons.download_rounded, size: 18),
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          final data = state.filteredItems.map((i) => {
                                'Report ID': i.id,
                                'Resume ID': i.resumeId,
                                'Resume Title': i.resumeTitle,
                                'User Email': i.userEmail,
                                'Share Slug': i.shareSlug,
                                'Reason': i.reportReason,
                                'Reported By': i.reportedBy,
                                'Date': DateFormat('yyyy-MM-dd HH:mm')
                                    .format(i.reportedAt),
                                'Status': i.status,
                                'Moderator Notes': i.moderatorNotes ?? '',
                              }).toList();
                          CsvExporter.exportToCsv(
                            fileName:
                                'resumeforge_moderation_queue_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
                            data: data,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Moderation queue exported to CSV'),
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
            const SizedBox(height: 20),

            // Main Content Table
            Expanded(
              child: AppCard(
                padding: EdgeInsets.zero,
                child: state.filteredItems.isEmpty
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
                                headingRowHeight: 48,
                                dataRowMinHeight: 64,
                                dataRowMaxHeight: 72,
                                headingRowColor: WidgetStateProperty.all(
                                  AppColors.surface(context),
                                ),
                                columns: const [
                                  DataColumn(
                                    label: Text('Report ID & Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  DataColumn(
                                    label: Text('Resume & User',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  DataColumn(
                                    label: Text('Public Share Link',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  DataColumn(
                                    label: Text('Reason & Reporter',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  DataColumn(
                                    label: Text('Status',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                  DataColumn(
                                    label: Text('Actions',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ),
                                ],
                                rows: state.filteredItems.map((item) {
                                  return DataRow(
                                    cells: [
                                      // ID & Date
                                      DataCell(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.id,
                                              style: AppTextStyles.bodyMedium(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              DateFormat('dd MMM yyyy, HH:mm')
                                                  .format(item.reportedAt),
                                              style: AppTextStyles.bodySmall(
                                                color: AppColors.textSecondary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Resume & User
                                      DataCell(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              item.resumeTitle,
                                              style: AppTextStyles.bodyMedium(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${item.userName} (${item.userEmail})',
                                              style: AppTextStyles.bodySmall(
                                                color: AppColors.textSecondary(
                                                    context),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Public Share Link
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(Icons.link,
                                                size: 16,
                                                color: AppColors.primary),
                                            const SizedBox(width: 6),
                                            Text(
                                              item.shareSlug,
                                              style: AppTextStyles.bodySmall(
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Reason & Reporter
                                      DataCell(
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFDC2626)
                                                    .withOpacity(0.12),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: const Color(0xFFDC2626)
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                              child: Text(
                                                item.reportReason,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFFDC2626),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'By: ${item.reportedBy}',
                                              style: AppTextStyles.bodySmall(
                                                color: AppColors.textSecondary(
                                                    context),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Status Badge
                                      DataCell(_buildStatusBadge(item)),

                                      // Actions
                                      DataCell(
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // View details
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 20),
                                              tooltip: 'Inspect Report Details',
                                              onPressed: () =>
                                                  _showReportDetailsDialog(item),
                                            ),

                                            // Quarantine button (if pending)
                                            if (item.isPending)
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.shield_outlined,
                                                    size: 20,
                                                    color: AppColors.warning),
                                                tooltip:
                                                    'Quarantine Public Link',
                                                onPressed: () =>
                                                    _handleQuarantine(item),
                                              ),

                                            // Unshare / Revoke button
                                            if (!item.isUnshared)
                                              IconButton(
                                                icon: const Icon(
                                                    Icons.link_off_rounded,
                                                    size: 20,
                                                    color: AppColors.error),
                                                tooltip: 'Revoke Share URL',
                                                onPressed: () =>
                                                    _handleUnshare(item),
                                              ),

                                            // Dismiss button
                                            if (item.isPending)
                                              IconButton(
                                                icon: const Icon(
                                                    Icons
                                                        .check_circle_outline_rounded,
                                                    size: 20,
                                                    color: AppColors.success),
                                                tooltip: 'Dismiss Report',
                                                onPressed: () =>
                                                    _handleDismiss(item),
                                              ),
                                          ],
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsHeader(ModerationState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildMetricCard(
              title: 'Pending Reports',
              value: '${state.pendingCount}',
              subtitle: 'Requires immediate moderator review',
              icon: Icons.flag_rounded,
              iconColor: AppColors.warning,
              width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
            ),
            _buildMetricCard(
              title: 'Quarantined Links',
              value: '${state.quarantinedCount}',
              subtitle: 'Temporarily blocked from public view',
              icon: Icons.gpp_bad_rounded,
              iconColor: AppColors.error,
              width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
            ),
            _buildMetricCard(
              title: 'Total Tracked',
              value: '${state.items.length}',
              subtitle: 'Cumulative reports processed',
              icon: Icons.rule_folder_rounded,
              iconColor: AppColors.primary,
              width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
            ),
            _buildMetricCard(
              title: 'Avg Turnaround',
              value: '1.4 hrs',
              subtitle: '99.4% SLA adherence',
              icon: Icons.timer_outlined,
              iconColor: AppColors.success,
              width: isWide ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricCard({
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.h2(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.caption(
                    color: AppColors.textSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    String current,
    Function(String) onSelect, {
    int? count,
    Color? color,
  }) {
    final isSelected = current == value;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () => onSelect(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AppColors.primary).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.border(context),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall(
                color: isSelected
                    ? (color ?? AppColors.primary)
                    : AppColors.textSecondary(context),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (count != null && count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color ?? AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ModerationItem item) {
    switch (item.status) {
      case 'pending':
        return const AppBadge(
          text: 'Pending Review',
          variant: BadgeVariant.warning,
        );
      case 'quarantined':
        return const AppBadge(
          text: 'Quarantined',
          variant: BadgeVariant.error,
        );
      case 'dismissed':
        return const AppBadge(
          text: 'Dismissed',
          variant: BadgeVariant.success,
        );
      case 'unshared':
        return const AppBadge(
          text: 'Unshared',
          variant: BadgeVariant.info,
        );
      default:
        return AppBadge(text: item.status);
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.verified_user_outlined,
              size: 56,
              color: AppColors.success.withOpacity(0.8),
            ),
            const SizedBox(height: 16),
            Text(
              'No Moderation Flags Found',
              style: AppTextStyles.h3(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'All shared links are clear or matching your current filter criteria.',
              style: AppTextStyles.bodyMedium(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportDetailsDialog(ModerationItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.report_problem_rounded,
                color: AppColors.warning, size: 24),
            const SizedBox(width: 10),
            Text('Report Details (${item.id})', style: AppTextStyles.h3()),
          ],
        ),
        content: SizedBox(
          width: 580,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Resume Title', item.resumeTitle),
                _buildDetailRow('Resume ID', item.resumeId),
                _buildDetailRow('Owner', '${item.userName} (${item.userEmail})'),
                _buildDetailRow('Public URL', item.publicShareUrl),
                _buildDetailRow('Share Slug', item.shareSlug),
                const Divider(height: 24),
                _buildDetailRow('Report Reason', item.reportReason),
                _buildDetailRow('Reported By', item.reportedBy),
                _buildDetailRow('Reported At',
                    DateFormat('dd MMM yyyy, HH:mm:ss').format(item.reportedAt)),
                const SizedBox(height: 12),
                Text('Report Details / User Complaint:',
                    style: AppTextStyles.label()),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface(context),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border(context)),
                  ),
                  child: Text(
                    item.reportDetails,
                    style: AppTextStyles.bodyMedium(),
                  ),
                ),
                if (item.moderatorNotes != null) ...[
                  const SizedBox(height: 16),
                  Text('Moderator Resolution Notes:',
                      style: AppTextStyles.label()),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF166534).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.moderatorNotes!,
                          style: AppTextStyles.bodyMedium(
                            color: const Color(0xFF166534),
                          ),
                        ),
                        if (item.reviewedBy != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            'Reviewed by ${item.reviewedBy} at ${DateFormat('dd MMM yyyy HH:mm').format(item.reviewedAt!)}',
                            style: AppTextStyles.caption(
                              color: const Color(0xFF15803D),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: AppTextStyles.bodySmall(
                color: AppColors.textSecondary(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuarantine(ModerationItem item) async {
    final notesCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quarantine Shared Resume Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quarantining will temporarily disable public web access to "${item.shareSlug}" while keeping the user account active.',
              style: AppTextStyles.bodyMedium(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Moderator Reason / Notes',
                hintText: 'e.g. Identity verification requested',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Quarantine Link'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(moderationProvider.notifier).quarantineLink(
            item.id,
            notesCtrl.text.trim().isEmpty
                ? 'Quarantined by moderator.'
                : notesCtrl.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Public link ${item.shareSlug} has been quarantined.'),
            backgroundColor: AppColors.warning,
          ),
        );
      }
    }
    notesCtrl.dispose();
  }

  Future<void> _handleUnshare(ModerationItem item) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Revoke Public Share URL?',
      message:
          'This will permanently revoke the public link "${item.shareSlug}". Anyone visiting the link will receive a 404/revoked notice.',
      confirmText: 'Revoke URL',
      type: ConfirmDialogType.danger,
    );

    if (confirmed == true) {
      await ref.read(moderationProvider.notifier).unshareLink(item.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Public share URL ${item.shareSlug} permanently revoked.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDismiss(ModerationItem item) async {
    final notesCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dismiss Moderation Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dismissing indicates this report is a false positive or has been resolved without action.',
              style: AppTextStyles.bodyMedium(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesCtrl,
              decoration: const InputDecoration(
                labelText: 'Resolution Notes',
                hintText: 'e.g. Valid portfolio verified',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Dismiss Report'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(moderationProvider.notifier).dismissReport(
            item.id,
            notesCtrl.text.trim(),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report marked as dismissed.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
    notesCtrl.dispose();
  }
}
