import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend_admin/app/theme/app_colors.dart';
import 'package:frontend_admin/app/theme/app_text_styles.dart';
import 'package:frontend_admin/core/widgets/app_badge.dart';
import 'package:frontend_admin/core/widgets/app_button.dart';
import 'package:frontend_admin/core/widgets/app_card.dart';
import 'package:frontend_admin/core/widgets/app_text_field.dart';
import 'package:frontend_admin/core/widgets/confirm_dialog.dart';
import 'package:frontend_admin/features/admin/dashboard/presentation/widgets/admin_layout.dart';
import '../../domain/entities/admin_announcement.dart';
import '../providers/admin_notifications_provider.dart';

class AdminNotificationsPage extends ConsumerStatefulWidget {
  const AdminNotificationsPage({super.key});

  @override
  ConsumerState<AdminNotificationsPage> createState() =>
      _AdminNotificationsPageState();
}

class _AdminNotificationsPageState
    extends ConsumerState<AdminNotificationsPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminNotificationsProvider);
    final notifier = ref.read(adminNotificationsProvider.notifier);

    return AdminLayout(
      title: 'Broadcasts & Notifications',
      currentPath: '/admin/notifications',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Metrics Header
            _buildMetricsHeader(state),
            const SizedBox(height: 24),

            // Controls & Compose Row
            AppCard(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 750;
                  return Flex(
                    direction: isWide ? Axis.horizontal : Axis.vertical,
                    children: [
                      Expanded(
                        flex: isWide ? 3 : 0,
                        child: AppTextField(
                          controller: _searchCtrl,
                          hintText: 'Search announcements by title or content...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          onChanged: (val) => notifier.setSearchQuery(val),
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterPill('All Audiences', 'all',
                                state.filterAudience, (a) => notifier.setFilterAudience(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('All Users', 'all_users',
                                state.filterAudience, (a) => notifier.setFilterAudience(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('Free Only', 'free_only',
                                state.filterAudience, (a) => notifier.setFilterAudience(a)),
                            const SizedBox(width: 8),
                            _buildFilterPill('Pro Only', 'pro_only',
                                state.filterAudience, (a) => notifier.setFilterAudience(a)),
                          ],
                        ),
                      ),
                      SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                      AppButton(
                        text: 'Compose Broadcast',
                        icon: const Icon(Icons.campaign_rounded, size: 18),
                        onPressed: () => _showComposeDialog(context, notifier),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Announcement Cards Grid
            if (state.filteredAnnouncements.isEmpty)
              _buildEmptyState()
            else
              ...state.filteredAnnouncements.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildAnnouncementCard(item, notifier),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsHeader(AdminNotificationsState state) {
    final activeCount = state.announcements.where((a) => a.isPublished).length;
    final totalReads =
        state.announcements.fold<int>(0, (sum, a) => sum + a.readCount);

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
              title: 'Active In-App Banners',
              value: '$activeCount',
              subtitle: 'Live for targeted job-seekers',
              icon: Icons.notifications_active_rounded,
              iconColor: AppColors.primary,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Total Impressions',
              value: NumberFormat('#,##,###').format(totalReads),
              subtitle: 'Unique user views across web',
              icon: Icons.visibility_rounded,
              iconColor: const Color(0xFF0284C7),
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Average CTR',
              value: '14.8%',
              subtitle: 'Upgrade & CTA conversions',
              icon: Icons.ads_click_rounded,
              iconColor: AppColors.success,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Delivery Status',
              value: '100% Up',
              subtitle: 'Zero webhook / push latency',
              icon: Icons.check_circle_rounded,
              iconColor: const Color(0xFF10B981),
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
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.caption(
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
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

  Widget _buildAnnouncementCard(
      AdminAnnouncement item, AdminNotificationsNotifier notifier) {
    Color bannerBg;
    Color bannerBorder;
    IconData bannerIcon;

    switch (item.bannerType) {
      case 'promo':
        bannerBg = const Color(0xFF7C3AED).withOpacity(0.12);
        bannerBorder = const Color(0xFF7C3AED).withOpacity(0.3);
        bannerIcon = Icons.stars_rounded;
        break;
      case 'maintenance':
        bannerBg = const Color(0xFFD97706).withOpacity(0.12);
        bannerBorder = const Color(0xFFD97706).withOpacity(0.3);
        bannerIcon = Icons.warning_amber_rounded;
        break;
      case 'announcement':
        bannerBg = const Color(0xFF15803D).withOpacity(0.12);
        bannerBorder = const Color(0xFF15803D).withOpacity(0.3);
        bannerIcon = Icons.rocket_launch_rounded;
        break;
      default:
        bannerBg = AppColors.primary.withOpacity(0.12);
        bannerBorder = AppColors.primary.withOpacity(0.3);
        bannerIcon = Icons.info_outline_rounded;
    }

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: isWide
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: bannerBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: bannerBorder),
                        ),
                        child:
                            Icon(bannerIcon, size: 20, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: AppTextStyles.h3()),
                          const SizedBox(height: 2),
                          Text(
                            'Target: ${_formatAudience(item.targetAudience)} • Published by ${item.createdBy} • ${DateFormat('dd MMM yyyy, HH:mm').format(item.createdAt)}',
                            style: AppTextStyles.caption(
                                color: AppColors.textSecondary(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: isWide ? 0 : 10),
                  Row(
                    children: [
                      AppBadge(
                        text: item.isPublished ? 'Published' : 'Draft / Paused',
                        variant: item.isPublished
                            ? BadgeVariant.success
                            : BadgeVariant.neutral,
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: item.isPublished,
                        activeColor: AppColors.primary,
                        onChanged: (val) => notifier.togglePublish(item.id, val),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // Message Body Preview
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: bannerBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: bannerBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: AppTextStyles.bodyMedium(),
                ),
                if (item.actionLabel != null) ...[
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                    ),
                    onPressed: () {},
                    child: Text(item.actionLabel!,
                        style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Footer Metrics & Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_alt_outlined,
                      size: 16, color: AppColors.textSecondaryLight),
                  const SizedBox(width: 6),
                  Text(
                    '${item.readCount} Impressions',
                    style: AppTextStyles.caption(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    item.dismissable ? 'Dismissable by user' : 'Sticky Banner',
                    style: AppTextStyles.caption(
                        color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline,
                    size: 16, color: AppColors.error),
                label: const Text('Delete',
                    style: TextStyle(color: AppColors.error)),
                onPressed: () async {
                  final confirmed = await ConfirmDialog.show(
                    context: context,
                    title: 'Delete Announcement?',
                    message:
                        'This announcement will be permanently removed from all user feeds.',
                    confirmText: 'Delete',
                    type: ConfirmDialogType.danger,
                  );
                  if (confirmed == true) {
                    await notifier.deleteAnnouncement(item.id);
                  }
                },
              ),
            ],
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
            color: isSelected ? AppColors.primary : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  String _formatAudience(String audience) {
    switch (audience) {
      case 'all_users':
        return 'All Job-Seekers (1,240)';
      case 'pro_only':
        return 'Pro Plan Subscribers (498)';
      case 'free_only':
        return 'Free Tier Users (742)';
      case 'inactive_7d':
        return 'Inactive > 7 Days (180)';
      default:
        return audience;
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.campaign_outlined,
                size: 48, color: AppColors.textSecondaryLight),
            const SizedBox(height: 12),
            Text('No Broadcast Announcements Found', style: AppTextStyles.h3()),
          ],
        ),
      ),
    );
  }

  void _showComposeDialog(
      BuildContext context, AdminNotificationsNotifier notifier) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    final actionLabelCtrl = TextEditingController();
    final actionUrlCtrl = TextEditingController();
    String bannerType = 'announcement';
    String audience = 'all_users';
    bool dismissable = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Compose In-App Broadcast', style: AppTextStyles.h3()),
          content: SizedBox(
            width: 540,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Announcement Title',
                    controller: titleCtrl,
                    hintText: 'e.g. 🚀 Introducing STAR Bullet Point Optimizer',
                  ),
                  const SizedBox(height: 12),
                  Text('Message Body', style: AppTextStyles.label()),
                  const SizedBox(height: 6),
                  TextField(
                    controller: msgCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText:
                          'Describe the feature update, promotion, or notice clearly...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Banner Type', style: AppTextStyles.label()),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: bannerType,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'announcement',
                                    child: Text('🚀 Announcement')),
                                DropdownMenuItem(
                                    value: 'promo',
                                    child: Text('✨ Promo / Upgrade')),
                                DropdownMenuItem(
                                    value: 'info', child: Text('ℹ️ Info / Tip')),
                                DropdownMenuItem(
                                    value: 'maintenance',
                                    child: Text('⚠️ Maintenance Notice')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setDialogState(() => bannerType = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Target Segment',
                                style: AppTextStyles.label()),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: audience,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'all_users',
                                    child: Text('All Users (1,240)')),
                                DropdownMenuItem(
                                    value: 'free_only',
                                    child: Text('Free Tier Only (742)')),
                                DropdownMenuItem(
                                    value: 'pro_only',
                                    child: Text('Pro Subscribers (498)')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setDialogState(() => audience = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Call to Action Button Label (Optional)',
                          controller: actionLabelCtrl,
                          hintText: 'e.g. Try Now, Upgrade',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'Action Deep Link (Optional)',
                          controller: actionUrlCtrl,
                          hintText: 'e.g. /app/resumes/new',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    title: const Text('Allow user to dismiss banner'),
                    value: dismissable,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (v) {
                      if (v != null) {
                        setDialogState(() => dismissable = v);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                final item = AdminAnnouncement(
                  id: 'ANN-${DateTime.now().millisecondsSinceEpoch % 10000}',
                  title: titleCtrl.text.trim(),
                  message: msgCtrl.text.trim(),
                  targetAudience: audience,
                  bannerType: bannerType,
                  actionLabel: actionLabelCtrl.text.trim().isEmpty
                      ? null
                      : actionLabelCtrl.text.trim(),
                  actionUrl: actionUrlCtrl.text.trim().isEmpty
                      ? null
                      : actionUrlCtrl.text.trim(),
                  isPublished: true,
                  createdAt: DateTime.now(),
                  publishedAt: DateTime.now(),
                  dismissable: dismissable,
                  createdBy: 'Super Admin',
                );
                notifier.broadcastAnnouncement(item);
                Navigator.of(ctx).pop();
              },
              child: const Text('Broadcast Live Now'),
            ),
          ],
        ),
      ),
    );
  }
}
