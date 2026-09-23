import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/ai_tool_config.dart';

class AiOpsState {
  final bool globalAiEnabled;
  final List<AiToolConfig> tools;
  final String selectedToolId;
  final int totalCalls24h;
  final double avgLatencyTotal;
  final double estCostToday;
  final double globalErrorRate;
  final bool isLoading;
  final String? testResponse;
  final bool isTestingPrompt;

  const AiOpsState({
    this.globalAiEnabled = true,
    required this.tools,
    this.selectedToolId = 'jd_matcher',
    this.totalCalls24h = 18420,
    this.avgLatencyTotal = 1380.0,
    this.estCostToday = 24.60,
    this.globalErrorRate = 0.14,
    this.isLoading = false,
    this.testResponse,
    this.isTestingPrompt = false,
  });

  AiToolConfig? get selectedTool =>
      tools.firstWhere((t) => t.id == selectedToolId, orElse: () => tools.first);

  AiOpsState copyWith({
    bool? globalAiEnabled,
    List<AiToolConfig>? tools,
    String? selectedToolId,
    int? totalCalls24h,
    double? avgLatencyTotal,
    double? estCostToday,
    double? globalErrorRate,
    bool? isLoading,
    String? testResponse,
    bool? isTestingPrompt,
  }) {
    return AiOpsState(
      globalAiEnabled: globalAiEnabled ?? this.globalAiEnabled,
      tools: tools ?? this.tools,
      selectedToolId: selectedToolId ?? this.selectedToolId,
      totalCalls24h: totalCalls24h ?? this.totalCalls24h,
      avgLatencyTotal: avgLatencyTotal ?? this.avgLatencyTotal,
      estCostToday: estCostToday ?? this.estCostToday,
      globalErrorRate: globalErrorRate ?? this.globalErrorRate,
      isLoading: isLoading ?? this.isLoading,
      testResponse: testResponse ?? this.testResponse,
      isTestingPrompt: isTestingPrompt ?? this.isTestingPrompt,
    );
  }
}

class AiOpsNotifier extends StateNotifier<AiOpsState> {
  final Ref _ref;

  AiOpsNotifier(this._ref) : super(AiOpsState(tools: _initialTools));

  static final List<AiToolConfig> _initialTools = [
    const AiToolConfig(
      id: 'jd_matcher',
      name: 'JD Matcher & Keyword Extractor',
      description:
          'Analyzes job description requirements against resume text, calculating percentage match, missing keywords, and recruiter search signals.',
      isEnabled: true,
      primaryModel: 'gemini-1.5-pro',
      fallbackModel: 'gpt-4o',
      temperature: 0.2,
      maxTokens: 2048,
      freeTierDailyLimit: 3,
      proTierDailyLimit: 50,
      systemPrompt: '''You are an elite ATS algorithm & executive recruiter.
Analyze the following candidate resume against the provided Job Description.
Extract required technical skills, soft skills, and domain qualifications.
Calculate exact match score (0-100) and list missing critical keywords.

Resume: {{resume_text}}
Target Job Description: {{jd_text}}
Target Role: {{target_role}}

Output strictly in JSON format with keys: match_score, matching_keywords, missing_keywords, suggestions.''',
      availableVariables: ['{{resume_text}}', '{{jd_text}}', '{{target_role}}'],
      dailyUsageCount: 7850,
      avgLatencyMs: 1420.0,
      errorRatePercent: 0.08,
    ),
    const AiToolConfig(
      id: 'cover_letter',
      name: 'AI Cover Letter Tailor',
      description:
          'Generates high-converting, tailored cover letters matching company tone, hiring manager persona, and candidate strengths.',
      isEnabled: true,
      primaryModel: 'gemini-1.5-pro',
      fallbackModel: 'claude-3-5-sonnet',
      temperature: 0.65,
      maxTokens: 1500,
      freeTierDailyLimit: 2,
      proTierDailyLimit: 30,
      systemPrompt: '''You are an expert executive career coach.
Write a personalized 3-4 paragraph cover letter for {{target_role}} at {{company_name}}.
Incorporate the candidate's achievements from {{resume_text}} with measurable impact.
Avoid clichés and buzzwords. Ensure a confident, authentic, and persuasive tone.''',
      availableVariables: [
        '{{resume_text}}',
        '{{target_role}}',
        '{{company_name}}',
        '{{tone}}'
      ],
      dailyUsageCount: 4120,
      avgLatencyMs: 1650.0,
      errorRatePercent: 0.18,
    ),
    const AiToolConfig(
      id: 'star_bullets',
      name: 'STAR Bullet Point Optimizer',
      description:
          'Transforms basic resume job duties into high-impact STAR (Situation, Task, Action, Result) bullet points with metrics and strong action verbs.',
      isEnabled: true,
      primaryModel: 'gemini-1.5-flash',
      fallbackModel: 'gpt-4o-mini',
      temperature: 0.35,
      maxTokens: 1024,
      freeTierDailyLimit: 10,
      proTierDailyLimit: 200,
      systemPrompt: '''You are a senior resume editor specialized in Fortune 500 hiring standards.
Transform the input raw bullet point into 3 variations of quantifiable STAR statements.
Use Google X-Y-Z formula: "Accomplished [X] as measured by [Y], by doing [Z]".

Raw Bullet: {{raw_bullet}}
Role Context: {{job_title}} at {{company_name}}''',
      availableVariables: [
        '{{raw_bullet}}',
        '{{job_title}}',
        '{{company_name}}'
      ],
      dailyUsageCount: 5210,
      avgLatencyMs: 890.0,
      errorRatePercent: 0.05,
    ),
    const AiToolConfig(
      id: 'salary_estimator',
      name: 'Market Salary & Level Estimator',
      description:
          'Predicts market compensation range, seniority band, and negotiation leverage based on resume skill depth and target location.',
      isEnabled: true,
      primaryModel: 'gemini-1.5-flash',
      fallbackModel: 'gpt-4o',
      temperature: 0.1,
      maxTokens: 800,
      freeTierDailyLimit: 5,
      proTierDailyLimit: 50,
      systemPrompt: '''Analyze candidate years of experience, core tech stack, and location to estimate salary percentile brackets (25th, 50th, 75th, 90th).
Resume Summary: {{resume_text}}
Location: {{location}}
Target Title: {{target_role}}''',
      availableVariables: ['{{resume_text}}', '{{location}}', '{{target_role}}'],
      dailyUsageCount: 1240,
      avgLatencyMs: 760.0,
      errorRatePercent: 0.12,
    ),
  ];

  void selectTool(String toolId) {
    state = state.copyWith(selectedToolId: toolId, testResponse: null);
  }

  Future<void> toggleGlobalKillSwitch(bool enabled) async {
    state = state.copyWith(globalAiEnabled: enabled);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.aiKillSwitchToggled,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: 'GLOBAL_AI_SYSTEM',
          targetType: 'AiOpsGateway',
          description: enabled
              ? 'AI Global Kill-Switch deactivated. All AI services restored.'
              : 'EMERGENCY: AI Global Kill-Switch activated. All AI generations paused.',
          metadata: {'globalAiEnabled': enabled},
        );
  }

  Future<void> toggleToolEnabled(String toolId, bool enabled) async {
    final updated = state.tools.map((t) {
      if (t.id == toolId) {
        return t.copyWith(isEnabled: enabled);
      }
      return t;
    }).toList();

    state = state.copyWith(tools: updated);
    final tool = state.tools.firstWhere((t) => t.id == toolId);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.aiConfigUpdated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: toolId,
          targetType: 'AiToolConfig',
          description:
              'Changed AI tool status for "${tool.name}" to ${enabled ? "ACTIVE" : "DISABLED"}',
          metadata: {'toolId': toolId, 'isEnabled': enabled},
        );
  }

  Future<void> updateToolConfig(AiToolConfig updated) async {
    final updatedTools = state.tools.map((t) {
      if (t.id == updated.id) {
        return updated;
      }
      return t;
    }).toList();

    state = state.copyWith(tools: updatedTools);
    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.aiConfigUpdated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: updated.id,
          targetType: 'AiToolConfig',
          description:
              'Updated AI model config and system prompt for "${updated.name}" (Model: ${updated.primaryModel}, Temp: ${updated.temperature})',
          metadata: {
            'primaryModel': updated.primaryModel,
            'fallbackModel': updated.fallbackModel,
            'temperature': updated.temperature,
            'maxTokens': updated.maxTokens,
            'freeLimit': updated.freeTierDailyLimit,
            'proLimit': updated.proTierDailyLimit,
          },
        );
  }

  Future<void> testRunPrompt(String samplePrompt) async {
    state = state.copyWith(isTestingPrompt: true, testResponse: null);
    await Future.delayed(const Duration(milliseconds: 900));

    final response = '''{
  "status": "success",
  "model_used": "${state.selectedTool?.primaryModel ?? 'gemini-1.5-pro'}",
  "latency_ms": 842,
  "tokens_consumed": 412,
  "sample_output": "Parsed successfully with 94.2% ATS alignment score. Identified 14 required keywords and 3 recommended executive power-verbs."
}''';

    state = state.copyWith(
      isTestingPrompt: false,
      testResponse: response,
    );
  }
}

final aiOpsProvider =
    StateNotifierProvider<AiOpsNotifier, AiOpsState>((ref) {
  return AiOpsNotifier(ref);
});
