class PromoCode {
  final String id;
  final String code; // e.g. 'ATS100', 'PRO50'
  final String discountType; // 'percentage' | 'fixed_amount' | 'free_credits'
  final double discountValue; // 100 for 100%, 200 for ₹200
  final DateTime validFrom;
  final DateTime validUntil;
  final int maxRedemptions;
  final int redemptionCount;
  final bool isActive;
  final String applicablePlan; // 'pro_monthly' | 'pro_annual' | 'all'
  final String description;

  const PromoCode({
    required this.id,
    required this.code,
    required this.discountType,
    required this.discountValue,
    required this.validFrom,
    required this.validUntil,
    required this.maxRedemptions,
    required this.redemptionCount,
    required this.isActive,
    required this.applicablePlan,
    required this.description,
  });

  bool get isExpired => DateTime.now().isAfter(validUntil);
  bool get isMaxedOut => redemptionCount >= maxRedemptions;

  PromoCode copyWith({
    String? id,
    String? code,
    String? discountType,
    double? discountValue,
    DateTime? validFrom,
    DateTime? validUntil,
    int? maxRedemptions,
    int? redemptionCount,
    bool? isActive,
    String? applicablePlan,
    String? description,
  }) {
    return PromoCode(
      id: id ?? this.id,
      code: code ?? this.code,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      maxRedemptions: maxRedemptions ?? this.maxRedemptions,
      redemptionCount: redemptionCount ?? this.redemptionCount,
      isActive: isActive ?? this.isActive,
      applicablePlan: applicablePlan ?? this.applicablePlan,
      description: description ?? this.description,
    );
  }
}
