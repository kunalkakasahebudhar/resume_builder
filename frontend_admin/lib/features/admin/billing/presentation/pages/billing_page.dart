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
import '../../domain/entities/billing_transaction.dart';
import '../../domain/entities/promo_code.dart';
import '../providers/billing_admin_provider.dart';

class BillingPage extends ConsumerStatefulWidget {
  const BillingPage({super.key});

  @override
  ConsumerState<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends ConsumerState<BillingPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(billingAdminProvider);
    final notifier = ref.read(billingAdminProvider.notifier);

    return AdminLayout(
      title: 'Monetization, Billing & Promos',
      currentPath: '/admin/billing',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Revenue KPI Cards
            _buildMetricsHeader(state),
            const SizedBox(height: 24),

            // Tab Navigation & Action Bar
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: isWide
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTabButton(
                            label: 'Transactions & Invoices',
                            icon: Icons.receipt_long_rounded,
                            isActive: state.activeTab == 'transactions',
                            onTap: () => notifier.setActiveTab('transactions'),
                          ),
                          const SizedBox(width: 12),
                          _buildTabButton(
                            label: 'Promo Codes & Discounts',
                            icon: Icons.discount_outlined,
                            isActive: state.activeTab == 'promos',
                            count: state.promoCodes.length,
                            onTap: () => notifier.setActiveTab('promos'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isWide ? 0 : 12),
                    if (state.activeTab == 'promos')
                      AppButton(
                        text: 'Create Promo Code',
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () =>
                            _showCreatePromoDialog(context, notifier),
                      )
                    else
                      AppButton(
                        text: 'Export Ledger CSV',
                        icon: const Icon(Icons.download_rounded, size: 18),
                        variant: ButtonVariant.outline,
                        onPressed: () {
                          final data = state.filteredTransactions.map((t) => {
                                'Txn ID': t.id,
                                'User Name': t.userName,
                                'User Email': t.userEmail,
                                'Plan': t.plan,
                                'Amount': '₹${t.amount.toStringAsFixed(2)}',
                                'Status': t.status,
                                'Payment Method': t.paymentMethod,
                                'Promo Code': t.promoCodeUsed ?? 'None',
                                'Date': DateFormat('yyyy-MM-dd HH:mm')
                                    .format(t.createdAt),
                              }).toList();
                          CsvExporter.exportToCsv(
                            fileName:
                                'resumeforge_billing_ledger_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
                            data: data,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Billing transactions exported to CSV'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),

            // Tab Views
            if (state.activeTab == 'transactions')
              _buildTransactionsView(state, notifier)
            else
              _buildPromosView(state, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsHeader(BillingAdminState state) {
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
              title: 'Monthly Recurring Rev (MRR)',
              value: '₹${NumberFormat('#,##,###').format(state.mrr.toInt())}',
              subtitle: '+14.2% MoM growth',
              icon: Icons.currency_rupee_rounded,
              iconColor: AppColors.primary,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Active Pro Subscribers',
              value: '${state.activeSubscribers}',
              subtitle: '₹499/mo standard plan',
              icon: Icons.workspace_premium_rounded,
              iconColor: const Color(0xFFF59E0B),
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Gross Revenue (Month)',
              value:
                  '₹${NumberFormat('#,##,###').format(state.totalRevenueMonth.toInt())}',
              subtitle: 'Subscriptions + AI credits',
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.success,
              width: cardWidth,
            ),
            _buildMetricTile(
              title: 'Free → Pro Conversion',
              value: '${state.conversionRate}%',
              subtitle: 'Industry benchmark: 4.5%',
              icon: Icons.filter_alt_outlined,
              iconColor: const Color(0xFF0284C7),
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

  Widget _buildTabButton({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    int? count,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark ? const Color(0xFF1E293B) : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.border(context).withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive
                  ? AppColors.primary
                  : AppColors.textSecondary(context),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium(
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive
                    ? AppColors.primary
                    : AppColors.textSecondary(context),
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsView(
      BillingAdminState state, BillingAdminNotifier notifier) {
    return Column(
      children: [
        // Controls
        AppCard(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              return Flex(
                direction: isWide ? Axis.horizontal : Axis.vertical,
                children: [
                  Expanded(
                    flex: isWide ? 3 : 0,
                    child: AppTextField(
                      controller: _searchCtrl,
                      hintText: 'Search by Txn ID, customer name, email...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      onChanged: (val) => notifier.setSearchQuery(val),
                    ),
                  ),
                  SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterPill('All Statuses', 'all',
                            state.transactionStatusFilter, (s) => notifier.setStatusFilter(s)),
                        const SizedBox(width: 8),
                        _buildFilterPill('Paid', 'paid',
                            state.transactionStatusFilter, (s) => notifier.setStatusFilter(s),
                            color: AppColors.success),
                        const SizedBox(width: 8),
                        _buildFilterPill('Refunded', 'refunded',
                            state.transactionStatusFilter, (s) => notifier.setStatusFilter(s),
                            color: AppColors.warning),
                        const SizedBox(width: 8),
                        _buildFilterPill('Failed', 'failed',
                            state.transactionStatusFilter, (s) => notifier.setStatusFilter(s),
                            color: AppColors.error),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Table
        AppCard(
          padding: EdgeInsets.zero,
          child: state.filteredTransactions.isEmpty
              ? _buildEmptyView('No billing transactions found.')
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: 20,
                          horizontalMargin: 20,
                          headingRowColor: WidgetStateProperty.all(
                            AppColors.surface(context),
                          ),
                          columns: const [
                            DataColumn(
                                label: Text('Transaction ID',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Customer',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Plan & Method',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Amount',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Status',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Date',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                            DataColumn(
                                label: Text('Actions',
                                    style: TextStyle(fontWeight: FontWeight.w600))),
                          ],
                          rows: state.filteredTransactions.map((t) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    t.id,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(t.userName,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                      Text(t.userEmail,
                                          style: AppTextStyles.caption(
                                              color: AppColors.textSecondary(context))),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(t.plan,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500)),
                                      Text(t.paymentMethod,
                                          style: AppTextStyles.caption(
                                              color: AppColors.textSecondary(context))),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '₹${t.amount.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                ),
                                DataCell(_buildStatusBadge(t.status)),
                                DataCell(
                                  Text(
                                    DateFormat('dd MMM yyyy, HH:mm')
                                        .format(t.createdAt),
                                    style: AppTextStyles.caption(),
                                  ),
                                ),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (t.isPaid)
                                        TextButton.icon(
                                          icon: const Icon(Icons.undo_rounded,
                                              size: 16, color: AppColors.error),
                                          label: const Text('Refund',
                                              style: TextStyle(
                                                  color: AppColors.error)),
                                          onPressed: () => _handleIssueRefund(
                                              context, t, notifier),
                                        )
                                      else if (t.isRefunded)
                                        Text(
                                          'Refunded',
                                          style: AppTextStyles.caption(
                                              color: AppColors.textSecondary(context)),
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
      ],
    );
  }

  Widget _buildPromosView(
      BillingAdminState state, BillingAdminNotifier notifier) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cardWidth = isWide
            ? (constraints.maxWidth - 20) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 20,
          runSpacing: 20,
          children: state.filteredPromoCodes.map((promo) {
            final percent = (promo.redemptionCount / promo.maxRedemptions).clamp(0.0, 1.0);
            return SizedBox(
              width: cardWidth,
              child: AppCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Text(
                            promo.code,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                        Switch(
                          value: promo.isActive,
                          activeColor: AppColors.primary,
                          onChanged: (val) =>
                              notifier.togglePromoActive(promo.id, val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      promo.description,
                      style: AppTextStyles.bodyMedium(
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discount: ${promo.discountValue.toInt()}${promo.discountType == "percentage" ? "% OFF" : " INR OFF"} • Plan: ${promo.applicablePlan}',
                      style: AppTextStyles.bodySmall(
                          color: AppColors.textSecondary(context)),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Redemptions: ${promo.redemptionCount} / ${promo.maxRedemptions}',
                          style: AppTextStyles.caption(
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Valid until ${DateFormat('dd MMM yyyy').format(promo.validUntil)}',
                          style: AppTextStyles.caption(
                              color: promo.isExpired
                                  ? AppColors.error
                                  : AppColors.textSecondary(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: percent,
                      backgroundColor: AppColors.border(context),
                      color: percent >= 1.0
                          ? AppColors.error
                          : AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.delete_outline,
                            size: 16, color: AppColors.error),
                        label: const Text('Delete Code',
                            style: TextStyle(color: AppColors.error)),
                        onPressed: () async {
                          final confirmed = await ConfirmDialog.show(
                            context: context,
                            title: 'Delete Promo Code "${promo.code}"?',
                            message:
                                'This code will no longer be redeemable by users during checkout.',
                            confirmText: 'Delete Code',
                            type: ConfirmDialogType.danger,
                          );
                          if (confirmed == true) {
                            await notifier.deletePromoCode(promo.id);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildFilterPill(
    String label,
    String value,
    String current,
    Function(String) onSelect, {
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
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected
                ? (color ?? AppColors.primary)
                : AppColors.textSecondary(context),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    switch (status) {
      case 'paid':
        return const AppBadge(text: 'Paid', variant: BadgeVariant.success);
      case 'refunded':
        return const AppBadge(text: 'Refunded', variant: BadgeVariant.warning);
      case 'failed':
        return const AppBadge(text: 'Failed', variant: BadgeVariant.error);
      default:
        return AppBadge(text: status);
    }
  }

  Widget _buildEmptyView(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          text,
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary(context)),
        ),
      ),
    );
  }

  void _showCreatePromoDialog(
      BuildContext context, BillingAdminNotifier notifier) {
    final codeCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final valueCtrl = TextEditingController(text: '50');
    final limitCtrl = TextEditingController(text: '500');
    String type = 'percentage';
    String plan = 'all';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Create Discount Promo Code', style: AppTextStyles.h3()),
          content: SizedBox(
            width: 480,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    label: 'Coupon Code (e.g. ATS100, SUMMER50)',
                    controller: codeCtrl,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Description',
                    controller: descCtrl,
                    hintText: 'e.g. University Partner Discount',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Discount Type', style: AppTextStyles.label()),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: type,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'percentage',
                                    child: Text('Percentage (%)')),
                                DropdownMenuItem(
                                    value: 'fixed_amount',
                                    child: Text('Fixed (INR ₹)')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setDialogState(() => type = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'Discount Value',
                          controller: valueCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Max Redemptions Limit',
                          controller: limitCtrl,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Applicable Plan',
                                style: AppTextStyles.label()),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: plan,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'all', child: Text('All Plans')),
                                DropdownMenuItem(
                                    value: 'pro_monthly',
                                    child: Text('Pro Monthly')),
                                DropdownMenuItem(
                                    value: 'pro_annual',
                                    child: Text('Pro Annual')),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setDialogState(() => plan = v);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
                if (codeCtrl.text.trim().isEmpty) return;
                final promo = PromoCode(
                  id: 'PRM-${DateTime.now().millisecondsSinceEpoch % 10000}',
                  code: codeCtrl.text.trim().toUpperCase(),
                  description: descCtrl.text.trim(),
                  discountType: type,
                  discountValue: double.tryParse(valueCtrl.text) ?? 50.0,
                  maxRedemptions: int.tryParse(limitCtrl.text) ?? 500,
                  redemptionCount: 0,
                  validFrom: DateTime.now(),
                  validUntil: DateTime.now().add(const Duration(days: 30)),
                  isActive: true,
                  applicablePlan: plan,
                );
                notifier.createPromoCode(promo);
                Navigator.of(ctx).pop();
              },
              child: const Text('Create Promo Code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleIssueRefund(BuildContext context, BillingTransaction t,
      BillingAdminNotifier notifier) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Issue Refund for ${t.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to refund ₹${t.amount.toStringAsFixed(2)} to ${t.userEmail}?',
              style: AppTextStyles.bodyMedium(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(
                labelText: 'Refund Reason',
                hintText: 'e.g. Customer requested cancellation within 24h',
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Process Refund'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await notifier.issueRefund(
        t.id,
        reasonCtrl.text.trim().isEmpty
            ? 'Processed by admin'
            : reasonCtrl.text.trim(),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refund processed for transaction ${t.id}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
    reasonCtrl.dispose();
  }
}
