import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/billing_transaction.dart';
import '../../domain/entities/promo_code.dart';

class BillingAdminState {
  final List<PromoCode> promoCodes;
  final List<BillingTransaction> transactions;
  final double mrr;
  final int activeSubscribers;
  final double totalRevenueMonth;
  final double conversionRate;
  final String activeTab; // 'transactions' | 'promos'
  final String transactionStatusFilter;
  final String searchQuery;
  final bool isLoading;

  const BillingAdminState({
    required this.promoCodes,
    required this.transactions,
    this.mrr = 248500.0,
    this.activeSubscribers = 498,
    this.totalRevenueMonth = 392400.0,
    this.conversionRate = 8.4,
    this.activeTab = 'transactions',
    this.transactionStatusFilter = 'all',
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<BillingTransaction> get filteredTransactions {
    return transactions.where((t) {
      if (transactionStatusFilter != 'all' &&
          t.status != transactionStatusFilter) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return t.id.toLowerCase().contains(q) ||
            t.userName.toLowerCase().contains(q) ||
            t.userEmail.toLowerCase().contains(q) ||
            t.plan.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  List<PromoCode> get filteredPromoCodes {
    if (searchQuery.isEmpty) return promoCodes;
    final q = searchQuery.toLowerCase();
    return promoCodes
        .where((p) =>
            p.code.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  BillingAdminState copyWith({
    List<PromoCode>? promoCodes,
    List<BillingTransaction>? transactions,
    double? mrr,
    int? activeSubscribers,
    double? totalRevenueMonth,
    double? conversionRate,
    String? activeTab,
    String? transactionStatusFilter,
    String? searchQuery,
    bool? isLoading,
  }) {
    return BillingAdminState(
      promoCodes: promoCodes ?? this.promoCodes,
      transactions: transactions ?? this.transactions,
      mrr: mrr ?? this.mrr,
      activeSubscribers: activeSubscribers ?? this.activeSubscribers,
      totalRevenueMonth: totalRevenueMonth ?? this.totalRevenueMonth,
      conversionRate: conversionRate ?? this.conversionRate,
      activeTab: activeTab ?? this.activeTab,
      transactionStatusFilter:
          transactionStatusFilter ?? this.transactionStatusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BillingAdminNotifier extends StateNotifier<BillingAdminState> {
  final Ref _ref;

  BillingAdminNotifier(this._ref)
      : super(BillingAdminState(
          promoCodes: _initialPromos,
          transactions: _initialTransactions,
        ));

  static final List<PromoCode> _initialPromos = [
    PromoCode(
      id: 'PRM-01',
      code: 'ATS100',
      discountType: 'percentage',
      discountValue: 100,
      validFrom: DateTime.now().subtract(const Duration(days: 30)),
      validUntil: DateTime.now().add(const Duration(days: 60)),
      maxRedemptions: 500,
      redemptionCount: 312,
      isActive: true,
      applicablePlan: 'all',
      description: '100% Free Pro access for university partner students',
    ),
    PromoCode(
      id: 'PRM-02',
      code: 'PRO50',
      discountType: 'percentage',
      discountValue: 50,
      validFrom: DateTime.now().subtract(const Duration(days: 15)),
      validUntil: DateTime.now().add(const Duration(days: 15)),
      maxRedemptions: 1000,
      redemptionCount: 645,
      isActive: true,
      applicablePlan: 'pro_monthly',
      description: '50% off first month Pro membership (₹249)',
    ),
    PromoCode(
      id: 'PRM-03',
      code: 'EARLYBIRD200',
      discountType: 'fixed_amount',
      discountValue: 200,
      validFrom: DateTime.now().subtract(const Duration(days: 45)),
      validUntil: DateTime.now().subtract(const Duration(days: 2)),
      maxRedemptions: 200,
      redemptionCount: 200,
      isActive: false,
      applicablePlan: 'pro_annual',
      description: 'Flat ₹200 off annual plan (Expired)',
    ),
  ];

  static final List<BillingTransaction> _initialTransactions = [
    BillingTransaction(
      id: 'TXN-9021',
      userId: 'USR-102',
      userName: 'Vikram Joshi',
      userEmail: 'vikram.j@domain.io',
      amount: 499.00,
      currency: 'INR',
      status: 'paid',
      plan: 'Pro Monthly',
      paymentMethod: 'UPI - GooglePay',
      createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      promoCodeUsed: null,
    ),
    BillingTransaction(
      id: 'TXN-9020',
      userId: 'USR-105',
      userName: 'Ananya Sharma',
      userEmail: 'ananya.s@gmail.com',
      amount: 249.50,
      currency: 'INR',
      status: 'paid',
      plan: 'Pro Monthly',
      paymentMethod: 'Credit Card (Visa)',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      promoCodeUsed: 'PRO50',
    ),
    BillingTransaction(
      id: 'TXN-9019',
      userId: 'USR-204',
      userName: 'Rahul Verma',
      userEmail: 'rahul.v@techsecure.in',
      amount: 3999.00,
      currency: 'INR',
      status: 'paid',
      plan: 'Pro Annual',
      paymentMethod: 'NetBanking (HDFC)',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      promoCodeUsed: null,
    ),
    BillingTransaction(
      id: 'TXN-9018',
      userId: 'USR-311',
      userName: 'Sneha Patel',
      userEmail: 'sneha.p@outlook.com',
      amount: 499.00,
      currency: 'INR',
      status: 'refunded',
      plan: 'Pro Monthly',
      paymentMethod: 'UPI - PhonePe',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      refundReason: 'Accidental double charge requested via support ticket #481',
    ),
    BillingTransaction(
      id: 'TXN-9017',
      userId: 'USR-488',
      userName: 'Devendra Rao',
      userEmail: 'devendra@growthops.co',
      amount: 499.00,
      currency: 'INR',
      status: 'failed',
      plan: 'Pro Monthly',
      paymentMethod: 'Credit Card (Mastercard)',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  void setActiveTab(String tab) {
    state = state.copyWith(activeTab: tab);
  }

  void setStatusFilter(String status) {
    state = state.copyWith(transactionStatusFilter: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> createPromoCode(PromoCode promo) async {
    state = state.copyWith(promoCodes: [promo, ...state.promoCodes]);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.promoCodeCreated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: promo.code,
          targetType: 'PromoCode',
          description:
              'Created promo code "${promo.code}" (${promo.discountValue}${promo.discountType == "percentage" ? "%" : " INR"} off, Limit: ${promo.maxRedemptions})',
          metadata: {
            'code': promo.code,
            'discountType': promo.discountType,
            'discountValue': promo.discountValue,
            'maxRedemptions': promo.maxRedemptions,
          },
        );
  }

  Future<void> togglePromoActive(String id, bool active) async {
    final updated = state.promoCodes.map((p) {
      if (p.id == id) {
        return p.copyWith(isActive: active);
      }
      return p;
    }).toList();

    state = state.copyWith(promoCodes: updated);
    final promo = state.promoCodes.firstWhere((p) => p.id == id);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.promoCodeUpdated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: promo.code,
          targetType: 'PromoCode',
          description:
              'Promo code "${promo.code}" status changed to ${active ? "ACTIVE" : "INACTIVE"}',
          metadata: {'id': id, 'isActive': active},
        );
  }

  Future<void> deletePromoCode(String id) async {
    final promo = state.promoCodes.firstWhere((p) => p.id == id);
    state = state.copyWith(
      promoCodes: state.promoCodes.where((p) => p.id != id).toList(),
    );

    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.promoCodeDeleted,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: promo.code,
          targetType: 'PromoCode',
          description: 'Deleted promo code "${promo.code}"',
          metadata: {'id': id, 'code': promo.code},
        );
  }

  Future<void> issueRefund(String transactionId, String reason) async {
    final updated = state.transactions.map((t) {
      if (t.id == transactionId) {
        return t.copyWith(
          status: 'refunded',
          refundReason: reason,
        );
      }
      return t;
    }).toList();

    state = state.copyWith(transactions: updated);
    final txn = state.transactions.firstWhere((t) => t.id == transactionId);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.subscriptionRefunded,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: transactionId,
          targetType: 'BillingTransaction',
          description:
              'Issued full refund of ₹${txn.amount} for user ${txn.userEmail}. Reason: $reason',
          metadata: {
            'transactionId': transactionId,
            'amount': txn.amount,
            'userEmail': txn.userEmail,
            'reason': reason,
          },
        );
  }
}

final billingAdminProvider =
    StateNotifierProvider<BillingAdminNotifier, BillingAdminState>((ref) {
  return BillingAdminNotifier(ref);
});
