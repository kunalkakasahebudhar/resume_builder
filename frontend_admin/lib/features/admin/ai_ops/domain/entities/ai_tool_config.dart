class AiToolConfig {
  final String id; // 'jd_matcher', 'cover_letter', 'star_bullets', 'salary_estimator', 'tone_enhancer'
  final String name;
  final String description;
  final bool isEnabled;
  final String primaryModel; // 'gemini-1.5-pro', 'gemini-1.5-flash', 'gpt-4o', 'claude-3-5-sonnet'
  final String fallbackModel;
  final double temperature; // 0.0 - 1.0
  final int maxTokens;
  final int freeTierDailyLimit;
  final int proTierDailyLimit;
  final String systemPrompt;
  final List<String> availableVariables;
  final int dailyUsageCount;
  final double avgLatencyMs;
  final double errorRatePercent;

  const AiToolConfig({
    required this.id,
    required this.name,
    required this.description,
    required this.isEnabled,
    required this.primaryModel,
    required this.fallbackModel,
    required this.temperature,
    required this.maxTokens,
    required this.freeTierDailyLimit,
    required this.proTierDailyLimit,
    required this.systemPrompt,
    required this.availableVariables,
    required this.dailyUsageCount,
    required this.avgLatencyMs,
    required this.errorRatePercent,
  });

  AiToolConfig copyWith({
    String? id,
    String? name,
    String? description,
    bool? isEnabled,
    String? primaryModel,
    String? fallbackModel,
    double? temperature,
    int? maxTokens,
    int? freeTierDailyLimit,
    int? proTierDailyLimit,
    String? systemPrompt,
    List<String>? availableVariables,
    int? dailyUsageCount,
    double? avgLatencyMs,
    double? errorRatePercent,
  }) {
    return AiToolConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isEnabled: isEnabled ?? this.isEnabled,
      primaryModel: primaryModel ?? this.primaryModel,
      fallbackModel: fallbackModel ?? this.fallbackModel,
      temperature: temperature ?? this.temperature,
      maxTokens: maxTokens ?? this.maxTokens,
      freeTierDailyLimit: freeTierDailyLimit ?? this.freeTierDailyLimit,
      proTierDailyLimit: proTierDailyLimit ?? this.proTierDailyLimit,
      systemPrompt: systemPrompt ?? this.systemPrompt,
      availableVariables: availableVariables ?? this.availableVariables,
      dailyUsageCount: dailyUsageCount ?? this.dailyUsageCount,
      avgLatencyMs: avgLatencyMs ?? this.avgLatencyMs,
      errorRatePercent: errorRatePercent ?? this.errorRatePercent,
    );
  }
}
