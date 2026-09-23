class BillingTransaction {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final double amount;
  final String currency; // 'INR' | 'USD'
  final String status; // 'paid' | 'refunded' | 'failed'
  final String plan; // 'Pro Monthly' | 'Pro Annual' | 'AI Credits Pack'
  final String paymentMethod; // 'UPI - GooglePay' | 'Credit Card (Visa)' | 'Razorpay'
  final DateTime createdAt;
  final String? promoCodeUsed;
  final String? invoiceUrl;
  final String? refundReason;

  const BillingTransaction({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.amount,
    required this.currency,
    required this.status,
    required this.plan,
    required this.paymentMethod,
    required this.createdAt,
    this.promoCodeUsed,
    this.invoiceUrl,
    this.refundReason,
  });

  bool get isPaid => status == 'paid';
  bool get isRefunded => status == 'refunded';
  bool get isFailed => status == 'failed';

  BillingTransaction copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    double? amount,
    String? currency,
    String? status,
    String? plan,
    String? paymentMethod,
    DateTime? createdAt,
    String? promoCodeUsed,
    String? invoiceUrl,
    String? refundReason,
  }) {
    return BillingTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      plan: plan ?? this.plan,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      promoCodeUsed: promoCodeUsed ?? this.promoCodeUsed,
      invoiceUrl: invoiceUrl ?? this.invoiceUrl,
      refundReason: refundReason ?? this.refundReason,
    );
  }
}
