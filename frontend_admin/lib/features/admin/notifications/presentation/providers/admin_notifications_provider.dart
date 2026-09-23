import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/admin_announcement.dart';

class AdminNotificationsState {
  final List<AdminAnnouncement> announcements;
  final String filterAudience;
  final String searchQuery;
  final bool isLoading;

  const AdminNotificationsState({
    required this.announcements,
    this.filterAudience = 'all',
    this.searchQuery = '',
    this.isLoading = false,
  });

  List<AdminAnnouncement> get filteredAnnouncements {
    return announcements.where((a) {
      if (filterAudience != 'all' && a.targetAudience != filterAudience) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return a.title.toLowerCase().contains(q) ||
            a.message.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  AdminNotificationsState copyWith({
    List<AdminAnnouncement>? announcements,
    String? filterAudience,
    String? searchQuery,
    bool? isLoading,
  }) {
    return AdminNotificationsState(
      announcements: announcements ?? this.announcements,
      filterAudience: filterAudience ?? this.filterAudience,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AdminNotificationsNotifier
    extends StateNotifier<AdminNotificationsState> {
  final Ref _ref;

  AdminNotificationsNotifier(this._ref)
      : super(AdminNotificationsState(announcements: _initialAnnouncements));

  static final List<AdminAnnouncement> _initialAnnouncements = [
    AdminAnnouncement(
      id: 'ANN-301',
      title: '🚀 New AI Cover Letter Tailor Now Live!',
      message:
          'Match your resume achievements directly to job requirements and generate high-impact executive cover letters in seconds.',
      targetAudience: 'all_users',
      bannerType: 'announcement',
      actionLabel: 'Try Cover Letter Generator',
      actionUrl: '/app/ai-suite/cover-letter',
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      publishedAt: DateTime.now().subtract(const Duration(days: 2)),
      dismissable: true,
      readCount: 1840,
      createdBy: 'Super Admin',
    ),
    AdminAnnouncement(
      id: 'ANN-302',
      title: '✨ 50% Off Annual Pro Upgrade - Use Code PRO50',
      message:
          'Unlock unlimited ATS deep scans, JD match scoring, and all 11 premium templates for ₹2,499/year.',
      targetAudience: 'free_only',
      bannerType: 'promo',
      actionLabel: 'Upgrade to Pro',
      actionUrl: '/app/pricing',
      isPublished: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      publishedAt: DateTime.now().subtract(const Duration(days: 5)),
      dismissable: true,
      readCount: 3120,
      createdBy: 'Growth Team',
    ),
    AdminAnnouncement(
      id: 'ANN-303',
      title: '⚠️ Scheduled System Maintenance Notice',
      message:
          'Resume Forge database engine upgrade scheduled for Sunday, 02:00 AM - 04:00 AM IST. Resumes will remain accessible in read-only mode.',
      targetAudience: 'all_users',
      bannerType: 'maintenance',
      isPublished: false,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      dismissable: false,
      readCount: 890,
      createdBy: 'DevOps Lead',
    ),
  ];

  void setFilterAudience(String audience) {
    state = state.copyWith(filterAudience: audience);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> broadcastAnnouncement(AdminAnnouncement item) async {
    state = state.copyWith(announcements: [item, ...state.announcements]);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.announcementBroadcasted,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: item.id,
          targetType: 'AdminAnnouncement',
          description:
              'Broadcasted in-app announcement "${item.title}" to target segment "${item.targetAudience}"',
          metadata: {
            'id': item.id,
            'title': item.title,
            'targetAudience': item.targetAudience,
            'bannerType': item.bannerType,
          },
        );
  }

  Future<void> togglePublish(String id, bool publish) async {
    final updated = state.announcements.map((a) {
      if (a.id == id) {
        return a.copyWith(
          isPublished: publish,
          publishedAt: publish ? DateTime.now() : a.publishedAt,
        );
      }
      return a;
    }).toList();

    state = state.copyWith(announcements: updated);
    final item = state.announcements.firstWhere((a) => a.id == id);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.announcementBroadcasted,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: item.id,
          targetType: 'AdminAnnouncement',
          description:
              'Changed announcement "${item.title}" publish status to ${publish ? "PUBLISHED" : "UNPUBLISHED"}',
          metadata: {'id': id, 'isPublished': publish},
        );
  }

  Future<void> deleteAnnouncement(String id) async {
    state = state.copyWith(
      announcements: state.announcements.where((a) => a.id != id).toList(),
    );
  }
}

final adminNotificationsProvider = StateNotifierProvider<
    AdminNotificationsNotifier, AdminNotificationsState>((ref) {
  return AdminNotificationsNotifier(ref);
});
