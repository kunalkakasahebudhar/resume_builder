class AdminAnnouncement {
  final String id;
  final String title;
  final String message;
  final String targetAudience; // 'all_users' | 'pro_only' | 'free_only' | 'inactive_7d'
  final String bannerType; // 'info' | 'announcement' | 'maintenance' | 'promo'
  final String? actionUrl;
  final String? actionLabel;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime? publishedAt;
  final bool dismissable;
  final int readCount;
  final String createdBy;

  const AdminAnnouncement({
    required this.id,
    required this.title,
    required this.message,
    required this.targetAudience,
    required this.bannerType,
    this.actionUrl,
    this.actionLabel,
    this.isPublished = true,
    required this.createdAt,
    this.publishedAt,
    this.dismissable = true,
    this.readCount = 0,
    required this.createdBy,
  });

  AdminAnnouncement copyWith({
    String? id,
    String? title,
    String? message,
    String? targetAudience,
    String? bannerType,
    String? actionUrl,
    String? actionLabel,
    bool? isPublished,
    DateTime? createdAt,
    DateTime? publishedAt,
    bool? dismissable,
    int? readCount,
    String? createdBy,
  }) {
    return AdminAnnouncement(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      targetAudience: targetAudience ?? this.targetAudience,
      bannerType: bannerType ?? this.bannerType,
      actionUrl: actionUrl ?? this.actionUrl,
      actionLabel: actionLabel ?? this.actionLabel,
      isPublished: isPublished ?? this.isPublished,
      createdAt: createdAt ?? this.createdAt,
      publishedAt: publishedAt ?? this.publishedAt,
      dismissable: dismissable ?? this.dismissable,
      readCount: readCount ?? this.readCount,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
