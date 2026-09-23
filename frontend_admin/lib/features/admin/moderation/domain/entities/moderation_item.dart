class ModerationItem {
  final String id;
  final String resumeId;
  final String resumeTitle;
  final String userId;
  final String userName;
  final String userEmail;
  final String publicShareUrl;
  final String shareSlug;
  final String reportReason;
  final String reportDetails;
  final String reportedBy;
  final DateTime reportedAt;
  final String status; // 'pending' | 'quarantined' | 'dismissed' | 'unshared'
  final String? moderatorNotes;
  final String? reviewedBy;
  final DateTime? reviewedAt;

  const ModerationItem({
    required this.id,
    required this.resumeId,
    required this.resumeTitle,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.publicShareUrl,
    required this.shareSlug,
    required this.reportReason,
    required this.reportDetails,
    required this.reportedBy,
    required this.reportedAt,
    this.status = 'pending',
    this.moderatorNotes,
    this.reviewedBy,
    this.reviewedAt,
  });

  bool get isPending => status == 'pending';
  bool get isQuarantined => status == 'quarantined';
  bool get isDismissed => status == 'dismissed';
  bool get isUnshared => status == 'unshared';

  ModerationItem copyWith({
    String? id,
    String? resumeId,
    String? resumeTitle,
    String? userId,
    String? userName,
    String? userEmail,
    String? publicShareUrl,
    String? shareSlug,
    String? reportReason,
    String? reportDetails,
    String? reportedBy,
    DateTime? reportedAt,
    String? status,
    String? moderatorNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
  }) {
    return ModerationItem(
      id: id ?? this.id,
      resumeId: resumeId ?? this.resumeId,
      resumeTitle: resumeTitle ?? this.resumeTitle,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      publicShareUrl: publicShareUrl ?? this.publicShareUrl,
      shareSlug: shareSlug ?? this.shareSlug,
      reportReason: reportReason ?? this.reportReason,
      reportDetails: reportDetails ?? this.reportDetails,
      reportedBy: reportedBy ?? this.reportedBy,
      reportedAt: reportedAt ?? this.reportedAt,
      status: status ?? this.status,
      moderatorNotes: moderatorNotes ?? this.moderatorNotes,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
    );
  }
}
