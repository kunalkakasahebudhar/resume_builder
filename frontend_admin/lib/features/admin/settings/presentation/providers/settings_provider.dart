import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/feature_flag.dart';

class SettingsState {
  final List<FeatureFlag> flags;
  final PlatformConfig config;
  final String selectedCategory;
  final String searchQuery;
  final bool isSaving;

  const SettingsState({
    required this.flags,
    required this.config,
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.isSaving = false,
  });

  List<FeatureFlag> get filteredFlags {
    return flags.where((f) {
      if (selectedCategory != 'all' && f.category != selectedCategory) {
        return false;
      }
      if (searchQuery.isNotEmpty) {
        final q = searchQuery.toLowerCase();
        return f.name.toLowerCase().contains(q) ||
            f.key.toLowerCase().contains(q) ||
            f.description.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  SettingsState copyWith({
    List<FeatureFlag>? flags,
    PlatformConfig? config,
    String? selectedCategory,
    String? searchQuery,
    bool? isSaving,
  }) {
    return SettingsState(
      flags: flags ?? this.flags,
      config: config ?? this.config,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref _ref;

  SettingsNotifier(this._ref)
      : super(const SettingsState(
          flags: _initialFlags,
          config: _initialConfig,
        ));

  static const PlatformConfig _initialConfig = PlatformConfig(
    appName: 'Resume Forge',
    supportEmail: 'support@resumeforge.app',
    maxFreeResumes: 3,
    maxProResumes: 50,
    maintenanceMode: false,
    aiRequestRateLimitPerMin: 60,
    pdfExportWorkerThreads: 8,
    enablePublicSharing: true,
  );

  static const List<FeatureFlag> _initialFlags = [
    FeatureFlag(
      key: 'ai_suite_enabled',
      name: 'AI Suite (JD Matcher, STAR Kit, Cover Letter)',
      description:
          'Master kill-switch enabling all AI features for users on the editor workspace.',
      isEnabled: true,
      rolloutPercentage: 100,
      minPlan: 'free',
      category: 'ai',
    ),
    FeatureFlag(
      key: 'ats_heatmap_enabled',
      name: 'ATS Visual Keyword Density Heatmap',
      description:
          'Live highlighting of keyword occurrences and recruiter eye-tracking simulation.',
      isEnabled: true,
      rolloutPercentage: 100,
      minPlan: 'pro',
      category: 'editor',
    ),
    FeatureFlag(
      key: 'public_sharing_enabled',
      name: 'Public Web Resume URL Sharing',
      description:
          'Allows users to generate public vanity URLs (resumeforge.app/share/...) with analytics.',
      isEnabled: true,
      rolloutPercentage: 100,
      minPlan: 'free',
      category: 'growth',
    ),
    FeatureFlag(
      key: 'linkedin_fast_importer',
      name: 'LinkedIn PDF & Profile Fast Importer',
      description:
          'Parses uploaded LinkedIn PDF exports into structured resume sections in under 3 seconds.',
      isEnabled: true,
      rolloutPercentage: 100,
      minPlan: 'free',
      category: 'editor',
    ),
    FeatureFlag(
      key: 'multi_language_cv_export',
      name: 'Multi-lingual CV Generation (German / French)',
      description:
          'Experimental localized CV formats adhering to EU / Europass guidelines.',
      isEnabled: false,
      rolloutPercentage: 20,
      minPlan: 'pro',
      category: 'growth',
    ),
    FeatureFlag(
      key: 'client_side_pdf_renderer',
      name: 'Client-Side WebAssembly PDF Engine',
      description:
          'Renders pixel-perfect PDF on browser canvas instead of backend Node/Puppeteer worker.',
      isEnabled: true,
      rolloutPercentage: 75,
      minPlan: 'free',
      category: 'infrastructure',
    ),
  ];

  void setCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSearchQuery(String q) {
    state = state.copyWith(searchQuery: q);
  }

  Future<void> toggleFlag(String key, bool enabled) async {
    final updated = state.flags.map((f) {
      if (f.key == key) {
        return f.copyWith(isEnabled: enabled);
      }
      return f;
    }).toList();

    state = state.copyWith(flags: updated);
    final flag = state.flags.firstWhere((f) => f.key == key);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditActionType.featureFlagToggled,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: key,
          targetType: 'FeatureFlag',
          description:
              'Toggled feature flag "${flag.name}" to ${enabled ? "ENABLED" : "DISABLED"}',
          metadata: {'key': key, 'isEnabled': enabled},
        );
  }

  Future<void> updateRollout(String key, int percentage) async {
    final updated = state.flags.map((f) {
      if (f.key == key) {
        return f.copyWith(rolloutPercentage: percentage);
      }
      return f;
    }).toList();

    state = state.copyWith(flags: updated);
  }

  Future<void> toggleMaintenanceMode(bool enabled) async {
    state = state.copyWith(
      config: state.config.copyWith(maintenanceMode: enabled),
    );
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditActionType.maintenanceModeToggled,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: 'PLATFORM_SYSTEM',
          targetType: 'PlatformConfig',
          description: enabled
              ? 'EMERGENCY: Platform Maintenance Mode ENABLED. User app is displaying maintenance screen.'
              : 'Platform Maintenance Mode DISABLED. User traffic restored.',
          metadata: {'maintenanceMode': enabled},
        );
  }

  Future<void> updateConfig(PlatformConfig newConfig) async {
    state = state.copyWith(config: newConfig);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditActionType.platformSettingsUpdated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: 'GLOBAL_CONFIG',
          targetType: 'PlatformConfig',
          description:
              'Updated global platform configuration (Max Free Resumes: ${newConfig.maxFreeResumes}, Rate Limit: ${newConfig.aiRequestRateLimitPerMin} req/min)',
          metadata: {
            'maxFreeResumes': newConfig.maxFreeResumes,
            'maxProResumes': newConfig.maxProResumes,
            'rateLimit': newConfig.aiRequestRateLimitPerMin,
            'workers': newConfig.pdfExportWorkerThreads,
          },
        );
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier(ref);
});
