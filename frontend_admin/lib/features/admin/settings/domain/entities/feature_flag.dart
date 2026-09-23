class FeatureFlag {
  final String key;
  final String name;
  final String description;
  final bool isEnabled;
  final int rolloutPercentage; // 0 - 100
  final String minPlan; // 'free' | 'pro' | 'admin_only'
  final String category; // 'ai' | 'editor' | 'growth' | 'infrastructure'

  const FeatureFlag({
    required this.key,
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.rolloutPercentage,
    required this.minPlan,
    required this.category,
  });

  FeatureFlag copyWith({
    String? key,
    String? name,
    String? description,
    bool? isEnabled,
    int? rolloutPercentage,
    String? minPlan,
    String? category,
  }) {
    return FeatureFlag(
      key: key ?? this.key,
      name: name ?? this.name,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
      rolloutPercentage: rolloutPercentage ?? this.rolloutPercentage,
      minPlan: minPlan ?? this.minPlan,
      category: category ?? this.category,
    );
  }
}

class PlatformConfig {
  final String appName;
  final String supportEmail;
  final int maxFreeResumes;
  final int maxProResumes;
  final bool maintenanceMode;
  final int aiRequestRateLimitPerMin;
  final int pdfExportWorkerThreads;
  final bool enablePublicSharing;

  const PlatformConfig({
    required this.appName,
    required this.supportEmail,
    required this.maxFreeResumes,
    required this.maxProResumes,
    required this.maintenanceMode,
    required this.aiRequestRateLimitPerMin,
    required this.pdfExportWorkerThreads,
    required this.enablePublicSharing,
  });

  PlatformConfig copyWith({
    String? appName,
    String? supportEmail,
    int? maxFreeResumes,
    int? maxProResumes,
    bool? maintenanceMode,
    int? aiRequestRateLimitPerMin,
    int? pdfExportWorkerThreads,
    bool? enablePublicSharing,
  }) {
    return PlatformConfig(
      appName: appName ?? this.appName,
      supportEmail: supportEmail ?? this.supportEmail,
      maxFreeResumes: maxFreeResumes ?? this.maxFreeResumes,
      maxProResumes: maxProResumes ?? this.maxProResumes,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      aiRequestRateLimitPerMin:
          aiRequestRateLimitPerMin ?? this.aiRequestRateLimitPerMin,
      pdfExportWorkerThreads:
          pdfExportWorkerThreads ?? this.pdfExportWorkerThreads,
      enablePublicSharing: enablePublicSharing ?? this.enablePublicSharing,
    );
  }
}
