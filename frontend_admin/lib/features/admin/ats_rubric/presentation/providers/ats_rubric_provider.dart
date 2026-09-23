import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_admin/features/admin/audit_logs/domain/entities/audit_log.dart';
import 'package:frontend_admin/features/admin/audit_logs/presentation/providers/audit_logs_provider.dart';
import 'package:frontend_admin/features/admin/auth/presentation/providers/admin_auth_provider.dart';
import '../../domain/entities/ats_rubric_config.dart';

class AtsRubricState {
  final AtsRubricConfig config;
  final bool isSaving;
  final String? errorMessage;
  final String? successMessage;

  const AtsRubricState({
    required this.config,
    this.isSaving = false,
    this.errorMessage,
    this.successMessage,
  });

  AtsRubricState copyWith({
    AtsRubricConfig? config,
    bool? isSaving,
    String? errorMessage,
    String? successMessage,
  }) {
    return AtsRubricState(
      config: config ?? this.config,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class AtsRubricNotifier extends StateNotifier<AtsRubricState> {
  final Ref _ref;

  AtsRubricNotifier(this._ref)
      : super(AtsRubricState(config: _defaultConfig));

  static final AtsRubricConfig _defaultConfig = AtsRubricConfig(
    formattingWeight: 25.0,
    keywordWeight: 30.0,
    quantifiableImpactWeight: 20.0,
    completenessWeight: 15.0,
    brevityWeight: 10.0,
    strongTierThreshold: 80,
    moderateTierThreshold: 60,
    powerActionVerbs: [
      'Spearheaded',
      'Architected',
      'Orchestrated',
      'Optimized',
      'Accelerated',
      'Engineered',
      'Deployed',
      'Scaled',
      'Automated',
      'Streamlined',
      'Generated',
      'Pioneered',
    ],
    penalizedBuzzwords: [
      'Hardworking',
      'Synergy',
      'Go-getter',
      'Team player',
      'Detail-oriented',
      'Dynamic',
      'Out of the box',
      'Self-starter',
    ],
    enableTablePenalty: true,
    enableIconHeaderPenalty: true,
    lastCalibratedAt: DateTime.now().subtract(const Duration(days: 4)),
    calibratedBy: 'Super Admin (Lead Architect)',
  );

  void updateWeights({
    double? formatting,
    double? keyword,
    double? impact,
    double? completeness,
    double? brevity,
  }) {
    final updated = state.config.copyWith(
      formattingWeight: formatting ?? state.config.formattingWeight,
      keywordWeight: keyword ?? state.config.keywordWeight,
      quantifiableImpactWeight:
          impact ?? state.config.quantifiableImpactWeight,
      completenessWeight: completeness ?? state.config.completenessWeight,
      brevityWeight: brevity ?? state.config.brevityWeight,
    );
    state = state.copyWith(config: updated, errorMessage: null);
  }

  void updateThresholds(int strong, int moderate) {
    state = state.copyWith(
      config: state.config.copyWith(
        strongTierThreshold: strong,
        moderateTierThreshold: moderate,
      ),
    );
  }

  void addPowerVerb(String verb) {
    if (verb.trim().isEmpty) return;
    final trimmed = verb.trim();
    if (!state.config.powerActionVerbs.contains(trimmed)) {
      state = state.copyWith(
        config: state.config.copyWith(
          powerActionVerbs: [...state.config.powerActionVerbs, trimmed],
        ),
      );
    }
  }

  void removePowerVerb(String verb) {
    state = state.copyWith(
      config: state.config.copyWith(
        powerActionVerbs:
            state.config.powerActionVerbs.where((v) => v != verb).toList(),
      ),
    );
  }

  void addBuzzword(String word) {
    if (word.trim().isEmpty) return;
    final trimmed = word.trim();
    if (!state.config.penalizedBuzzwords.contains(trimmed)) {
      state = state.copyWith(
        config: state.config.copyWith(
          penalizedBuzzwords: [...state.config.penalizedBuzzwords, trimmed],
        ),
      );
    }
  }

  void removeBuzzword(String word) {
    state = state.copyWith(
      config: state.config.copyWith(
        penalizedBuzzwords:
            state.config.penalizedBuzzwords.where((w) => w != word).toList(),
      ),
    );
  }

  void toggleTablePenalty(bool val) {
    state = state.copyWith(
      config: state.config.copyWith(enableTablePenalty: val),
    );
  }

  void toggleIconPenalty(bool val) {
    state = state.copyWith(
      config: state.config.copyWith(enableIconHeaderPenalty: val),
    );
  }

  void resetToDefaults() {
    state = state.copyWith(config: _defaultConfig);
  }

  Future<bool> saveConfig() async {
    if (!state.config.isValid) {
      state = state.copyWith(
        errorMessage:
            'Total weight must sum exactly to 100.0% (Current sum: ${state.config.totalWeight.toStringAsFixed(1)}%)',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 600));

    final admin = _ref.read(adminAuthProvider).admin;
    final adminName = admin?.name ?? 'Super Admin';

    final savedConfig = state.config.copyWith(
      lastCalibratedAt: DateTime.now(),
      calibratedBy: adminName,
    );

    state = state.copyWith(
      config: savedConfig,
      isSaving: false,
      successMessage: 'ATS Rubric calibrated and live across all scoring engines.',
    );

    _ref.read(auditLogsProvider.notifier).log(
          action: AuditAction.atsRubricCalibrated,
          actor: adminName,
          actorEmail: admin?.email ?? 'admin@resumeforge.com',
          actorRole: admin?.role.name ?? 'super_admin',
          targetId: 'GLOBAL_ATS_SCORER',
          targetType: 'ScoringEngine',
          description:
              'Calibrated ATS scoring weights (Formatting: ${savedConfig.formattingWeight}%, Keyword: ${savedConfig.keywordWeight}%, Impact: ${savedConfig.quantifiableImpactWeight}%, Completeness: ${savedConfig.completenessWeight}%, Brevity: ${savedConfig.brevityWeight}%)',
          metadata: {
            'formatting': savedConfig.formattingWeight,
            'keywords': savedConfig.keywordWeight,
            'impact': savedConfig.quantifiableImpactWeight,
            'completeness': savedConfig.completenessWeight,
            'brevity': savedConfig.brevityWeight,
            'strongThreshold': savedConfig.strongTierThreshold,
            'moderateThreshold': savedConfig.moderateTierThreshold,
          },
        );

    return true;
  }
}

final atsRubricProvider =
    StateNotifierProvider<AtsRubricNotifier, AtsRubricState>((ref) {
  return AtsRubricNotifier(ref);
});
