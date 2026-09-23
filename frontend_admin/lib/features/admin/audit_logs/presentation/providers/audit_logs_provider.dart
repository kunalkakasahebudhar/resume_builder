import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/audit_log.dart';

class AuditLogsState {
  final List<AuditLog> logs;
  final bool isLoading;
  final String searchQuery;
  final String actionFilter;
  final AuditActionType? selectedAction;
  final String? selectedTargetEntity;

  const AuditLogsState({
    this.logs = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.actionFilter = 'all',
    this.selectedAction,
    this.selectedTargetEntity,
  });

  List<AuditLog> get filteredLogs {
    return logs.where((log) {
      if (actionFilter != 'all') {
        if (actionFilter == 'user_banned' &&
            log.actionType != AuditActionType.userBanned &&
            log.actionType != AuditActionType.userDeleted) {
          return false;
        }
        if (actionFilter == 'ai_kill_switch' &&
            log.actionType != AuditActionType.aiKillSwitchToggled &&
            log.actionType != AuditActionType.aiConfigUpdated &&
            log.actionType != AuditActionType.aiPromptEdited) {
          return false;
        }
        if (actionFilter == 'content_quarantined' &&
            log.actionType != AuditActionType.contentQuarantined &&
            log.actionType != AuditActionType.resumeQuarantined &&
            log.actionType != AuditActionType.shareLinkRevoked) {
          return false;
        }
        if (actionFilter == 'ats_rubric' &&
            log.actionType != AuditActionType.atsRubricCalibrated) {
          return false;
        }
      }

      final matchesSearch = searchQuery.isEmpty ||
          log.actorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.actorEmail.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.description.toLowerCase().contains(searchQuery.toLowerCase()) ||
          log.targetId.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesAction =
          selectedAction == null || log.actionType == selectedAction;
      final matchesEntity = selectedTargetEntity == null ||
          log.targetEntity == selectedTargetEntity;

      return matchesSearch && matchesAction && matchesEntity;
    }).toList();
  }

  AuditLogsState copyWith({
    List<AuditLog>? logs,
    bool? isLoading,
    String? searchQuery,
    String? actionFilter,
    AuditActionType? selectedAction,
    bool clearAction = false,
    String? selectedTargetEntity,
    bool clearEntity = false,
  }) {
    return AuditLogsState(
      logs: logs ?? this.logs,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      actionFilter: actionFilter ?? this.actionFilter,
      selectedAction:
          clearAction ? null : (selectedAction ?? this.selectedAction),
      selectedTargetEntity: clearEntity
          ? null
          : (selectedTargetEntity ?? this.selectedTargetEntity),
    );
  }
}

class AuditLogsNotifier extends StateNotifier<AuditLogsState> {
  AuditLogsNotifier() : super(const AuditLogsState()) {
    loadLogs();
  }

  void loadLogs() {
    state = state.copyWith(isLoading: true);

    final mockLogs = [
      AuditLog(
        id: 'LOG-101',
        actorId: 'admin-1',
        actorName: 'Kunal Udhar',
        actorEmail: 'admin@resumeforge.com',
        actorRole: 'Super Admin',
        actionType: AuditActionType.promoCodeCreated,
        targetEntity: 'PromoCode',
        targetId: 'ATS100',
        description: 'Created 100% discount promo code ATS100 for VIP university partners',
        beforeState: null,
        afterState: {'code': 'ATS100', 'discount': '100%', 'maxRedemptions': 500},
        ipAddress: '192.168.1.42',
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      ),
      AuditLog(
        id: 'LOG-102',
        actorId: 'admin-2',
        actorName: 'Alex Chen',
        actorEmail: 'alex.mod@resumeforge.com',
        actorRole: 'Content Moderator',
        actionType: AuditActionType.contentQuarantined,
        targetEntity: 'PublicShareLink',
        targetId: 'rf-8041-vikram',
        description: 'Quarantined public resume link due to suspected redirect spam',
        beforeState: {'status': 'active', 'isPublic': true},
        afterState: {'status': 'quarantined', 'isPublic': false, 'reason': 'Spam / Phishing'},
        ipAddress: '10.0.4.19',
        timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 24)),
      ),
      AuditLog(
        id: 'LOG-103',
        actorId: 'admin-1',
        actorName: 'Kunal Udhar',
        actorEmail: 'admin@resumeforge.com',
        actorRole: 'Super Admin',
        actionType: AuditActionType.atsRubricCalibrated,
        targetEntity: 'ScoringEngine',
        targetId: 'GLOBAL_ATS_SCORER',
        description: 'Calibrated ATS scoring weights (Formatting: 25%, Keywords: 30%, Impact: 20%)',
        beforeState: {'formatting': 20, 'keywords': 35},
        afterState: {'formatting': 25, 'keywords': 30, 'impact': 20},
        ipAddress: '192.168.1.42',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      AuditLog(
        id: 'LOG-104',
        actorId: 'admin-3',
        actorName: 'Priya Sharma',
        actorEmail: 'priya.support@resumeforge.com',
        actorRole: 'Support Agent',
        actionType: AuditActionType.userBanned,
        targetEntity: 'UserAccount',
        targetId: 'USR-441',
        description: 'Suspended user account for automated scraping abuse',
        beforeState: {'status': 'active'},
        afterState: {'status': 'inactive', 'reason': 'API abuse'},
        ipAddress: '172.16.0.8',
        timestamp: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      AuditLog(
        id: 'LOG-105',
        actorId: 'admin-1',
        actorName: 'Kunal Udhar',
        actorEmail: 'admin@resumeforge.com',
        actorRole: 'Super Admin',
        actionType: AuditActionType.announcementBroadcasted,
        targetEntity: 'AdminAnnouncement',
        targetId: 'ANN-301',
        description: 'Broadcasted announcement "🚀 New AI Cover Letter Tailor Now Live!" to All Users',
        beforeState: null,
        afterState: {'targetAudience': 'all_users', 'impressions': 1840},
        ipAddress: '192.168.1.42',
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    state = state.copyWith(logs: mockLogs, isLoading: false);
  }

  void log({
    required AuditActionType action,
    required String actor,
    required String actorEmail,
    required String actorRole,
    required String targetId,
    required String targetType,
    required String description,
    Map<String, dynamic>? metadata,
  }) {
    final newLog = AuditLog(
      id: 'LOG-${DateTime.now().millisecondsSinceEpoch}',
      actorId: 'admin-current',
      actorName: actor,
      actorEmail: actorEmail,
      actorRole: actorRole,
      actionType: action,
      targetEntity: targetType,
      targetId: targetId,
      description: description,
      afterState: metadata,
      ipAddress: '127.0.0.1 (Local Session)',
      timestamp: DateTime.now(),
    );

    state = state.copyWith(logs: [newLog, ...state.logs]);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setActionFilter(String filter) {
    state = state.copyWith(actionFilter: filter);
  }

  void setSelectedAction(AuditActionType? action) {
    if (action == null) {
      state = state.copyWith(clearAction: true);
    } else {
      state = state.copyWith(selectedAction: action);
    }
  }

  void setSelectedEntity(String? entity) {
    if (entity == null) {
      state = state.copyWith(clearEntity: true);
    } else {
      state = state.copyWith(selectedTargetEntity: entity);
    }
  }
}

final auditLogsProvider =
    StateNotifierProvider<AuditLogsNotifier, AuditLogsState>((ref) {
  return AuditLogsNotifier();
});
