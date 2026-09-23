import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/moderation_item.dart';

class ModerationState {
  final List<ModerationItem> items;
  final String statusFilter; // 'all' | 'pending' | 'quarantined' | 'dismissed' | 'unshared'
  final String searchQuery;
  final bool isLoading;
  final String? errorMessage;

  const ModerationState({
    required this.items,
    this.statusFilter = 'all',
    this.searchQuery = '',
    this.isLoading = false,
    this.errorMessage,
  });

  List<ModerationItem> get filteredItems {
    return items.where((item) {
      if (statusFilter != 'all' && item.status != statusFilter) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        final matchesTitle = item.resumeTitle.toLowerCase().contains(q);
        final matchesUser = item.userName.toLowerCase().contains(q) ||
            item.userEmail.toLowerCase().contains(q);
        final matchesSlug = item.shareSlug.toLowerCase().contains(q);
        final matchesReason = item.reportReason.toLowerCase().contains(q);
        return matchesTitle || matchesUser || matchesSlug || matchesReason;
      }
      return true;
    }).toList();
  }

  int get pendingCount => items.where((i) => i.isPending).length;
  int get quarantinedCount => items.where((i) => i.isQuarantined).length;

  ModerationState copyWith({
    List<ModerationItem>? items,
    String? statusFilter,
    String? searchQuery,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ModerationState(
      items: items ?? this.items,
      statusFilter: statusFilter ?? this.statusFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class ModerationNotifier extends StateNotifier<ModerationState> {
  final Ref _ref;

  ModerationNotifier(this._ref)
      : super(ModerationState(items: _initialMockItems));

  static final List<ModerationItem> _initialMockItems = [
    ModerationItem(
      id: 'MOD-901',
      resumeId: 'RES-8041',
      resumeTitle: 'Senior Full Stack Lead (Public)',
      userId: 'USR-102',
      userName: 'Vikram Joshi',
      userEmail: 'vikram.j@domain.io',
      publicShareUrl: 'https://resumeforge.app/share/rf-8041-vikram',
      shareSlug: 'rf-8041-vikram',
      reportReason: 'Spam / Phishing Link',
      reportDetails:
          'Contains disguised redirect link in project portfolio section pointing to suspicious casino website.',
      reportedBy: 'recruiter_scanner@talentmesh.com',
      reportedAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
      status: 'pending',
    ),
    ModerationItem(
      id: 'MOD-902',
      resumeId: 'RES-7729',
      resumeTitle: 'Product Manager Resume v3',
      userId: 'USR-105',
      userName: 'Ananya Sharma',
      userEmail: 'ananya.s@gmail.com',
      publicShareUrl: 'https://resumeforge.app/share/rf-7729-ananya',
      shareSlug: 'rf-7729-ananya',
      reportReason: 'PII Leak / Confidential Data',
      reportDetails:
          'User pasted internal unreleased API keys and confidential client contract amounts in achievements section.',
      reportedBy: 'security-lead@acme-corp.com',
      reportedAt: DateTime.now().subtract(const Duration(hours: 6)),
      status: 'pending',
    ),
    ModerationItem(
      id: 'MOD-903',
      resumeId: 'RES-6120',
      resumeTitle: 'Cybersecurity Analyst CV',
      userId: 'USR-204',
      userName: 'Rahul Verma',
      userEmail: 'rahul.v@techsecure.in',
      publicShareUrl: 'https://resumeforge.app/share/rf-6120-rahul',
      shareSlug: 'rf-6120-rahul',
      reportReason: 'Plagiarism / Stolen Identity',
      reportDetails:
          'Copied verbatim work history and patents from published IEEE researcher profile.',
      reportedBy: 'support@ieee.org',
      reportedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      status: 'quarantined',
      moderatorNotes:
          'Quarantined public link pending identity verification with government ID.',
      reviewedBy: 'Alex Chen (Content Moderator)',
      reviewedAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    ModerationItem(
      id: 'MOD-904',
      resumeId: 'RES-5089',
      resumeTitle: 'Junior Frontend Developer',
      userId: 'USR-311',
      userName: 'Sneha Patel',
      userEmail: 'sneha.p@outlook.com',
      publicShareUrl: 'https://resumeforge.app/share/rf-5089-sneha',
      shareSlug: 'rf-5089-sneha',
      reportReason: 'False Positive / Spam Flag',
      reportDetails:
          'Automated keyword heuristic flagged multiple mentions of "crypto wallet" in Web3 project.',
      reportedBy: 'automod_bot@resumeforge.internal',
      reportedAt: DateTime.now().subtract(const Duration(days: 2)),
      status: 'dismissed',
      moderatorNotes: 'Legitimate Web3 developer project portfolio. Dismissed.',
      reviewedBy: 'Kunal Udhar (Super Admin)',
      reviewedAt: DateTime.now().subtract(const Duration(days: 1, hours: 20)),
    ),
    ModerationItem(
      id: 'MOD-905',
      resumeId: 'RES-4012',
      resumeTitle: 'Marketing Consultant Portfolio',
      userId: 'USR-488',
      userName: 'Devendra Rao',
      userEmail: 'devendra@growthops.co',
      publicShareUrl: 'https://resumeforge.app/share/rf-4012-devendra',
      shareSlug: 'rf-4012-devendra',
      reportReason: 'Inappropriate Content',
      reportDetails:
          'Offensive hate speech in public summary statement.',
      reportedBy: 'hiring@flipkart.com',
      reportedAt: DateTime.now().subtract(const Duration(days: 3)),
      status: 'unshared',
      moderatorNotes: 'Public link revoked permanently and user warned.',
      reviewedBy: 'Alex Chen (Content Moderator)',
      reviewedAt: DateTime.now().subtract(const Duration(days: 2, hours: 12)),
    ),
  ];

  void setFilter(String status) {
    state = state.copyWith(statusFilter: status);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> quarantineLink(String id, String notes) async {
    final item = state.items.firstWhere((i) => i.id == id);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    final updatedItems = state.items.map((i) {
      if (i.id == id) {
        return i.copyWith(
          status: 'quarantined',
          moderatorNotes: notes,
          reviewedBy: adminName,
          reviewedAt: DateTime.now(),
        );
      }
      return i;
    }).toList();

    state = state.copyWith(items: updatedItems);

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.contentQuarantined,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: item.resumeId,
          targetType: 'PublicShareLink',
          description:
              'Quarantined public resume link ${item.shareSlug}. Reason: ${item.reportReason}',
          metadata: {
            'moderationId': item.id,
            'notes': notes,
            'shareSlug': item.shareSlug,
            'userId': item.userId,
          },
        );
  }

  Future<void> unshareLink(String id) async {
    final item = state.items.firstWhere((i) => i.id == id);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    final updatedItems = state.items.map((i) {
      if (i.id == id) {
        return i.copyWith(
          status: 'unshared',
          moderatorNotes: 'Public share link permanently revoked by moderator.',
          reviewedBy: adminName,
          reviewedAt: DateTime.now(),
        );
      }
      return i;
    }).toList();

    state = state.copyWith(items: updatedItems);

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.shareLinkRevoked,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: item.resumeId,
          targetType: 'PublicShareLink',
          description:
              'Revoked public share link ${item.shareSlug} for user ${item.userEmail}',
          metadata: {
            'moderationId': item.id,
            'shareSlug': item.shareSlug,
            'userId': item.userId,
          },
        );
  }

  Future<void> dismissReport(String id, String notes) async {
    final item = state.items.firstWhere((i) => i.id == id);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    final updatedItems = state.items.map((i) {
      if (i.id == id) {
        return i.copyWith(
          status: 'dismissed',
          moderatorNotes: notes.isEmpty ? 'Report investigated and dismissed.' : notes,
          reviewedBy: adminName,
          reviewedAt: DateTime.now(),
        );
      }
      return i;
    }).toList();

    state = state.copyWith(items: updatedItems);

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.contentDismissed,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: item.resumeId,
          targetType: 'PublicShareLink',
          description:
              'Dismissed moderation report ${item.id} for resume ${item.resumeTitle}',
          metadata: {
            'moderationId': item.id,
            'notes': notes,
            'shareSlug': item.shareSlug,
          },
        );
  }
}

final moderationProvider =
    StateNotifierProvider<ModerationNotifier, ModerationState>((ref) {
  return ModerationNotifier(ref);
});
