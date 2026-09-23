class AtsRubricConfig {
  final double formattingWeight; // e.g. 25.0
  final double keywordWeight; // e.g. 30.0
  final double quantifiableImpactWeight; // e.g. 20.0
  final double completenessWeight; // e.g. 15.0
  final double brevityWeight; // e.g. 10.0
  final int strongTierThreshold; // e.g. 80
  final int moderateTierThreshold; // e.g. 60
  final List<String> powerActionVerbs;
  final List<String> penalizedBuzzwords;
  final bool enableTablePenalty;
  final bool enableIconHeaderPenalty;
  final DateTime lastCalibratedAt;
  final String calibratedBy;

  const AtsRubricConfig({
    required this.formattingWeight,
    required this.keywordWeight,
    required this.quantifiableImpactWeight,
    required this.completenessWeight,
    required this.brevityWeight,
    required this.strongTierThreshold,
    required this.moderateTierThreshold,
    required this.powerActionVerbs,
    required this.penalizedBuzzwords,
    required this.enableTablePenalty,
    required this.enableIconHeaderPenalty,
    required this.lastCalibratedAt,
    required this.calibratedBy,
  });

  double get totalWeight =>
      formattingWeight +
      keywordWeight +
      quantifiableImpactWeight +
      completenessWeight +
      brevityWeight;

  bool get isValid => (totalWeight - 100.0).abs() < 0.01;

  AtsRubricConfig copyWith({
    double? formattingWeight,
    double? keywordWeight,
    double? quantifiableImpactWeight,
    double? completenessWeight,
    double? brevityWeight,
    int? strongTierThreshold,
    int? moderateTierThreshold,
    List<String>? powerActionVerbs,
    List<String>? penalizedBuzzwords,
    bool? enableTablePenalty,
    bool? enableIconHeaderPenalty,
    DateTime? lastCalibratedAt,
    String? calibratedBy,
  }) {
    return AtsRubricConfig(
      formattingWeight: formattingWeight ?? this.formattingWeight,
      keywordWeight: keywordWeight ?? this.keywordWeight,
      quantifiableImpactWeight:
          quantifiableImpactWeight ?? this.quantifiableImpactWeight,
      completenessWeight: completenessWeight ?? this.completenessWeight,
      brevityWeight: brevityWeight ?? this.brevityWeight,
      strongTierThreshold: strongTierThreshold ?? this.strongTierThreshold,
      moderateTierThreshold:
          moderateTierThreshold ?? this.moderateTierThreshold,
      powerActionVerbs: powerActionVerbs ?? this.powerActionVerbs,
      penalizedBuzzwords: penalizedBuzzwords ?? this.penalizedBuzzwords,
      enableTablePenalty: enableTablePenalty ?? this.enableTablePenalty,
      enableIconHeaderPenalty:
          enableIconHeaderPenalty ?? this.enableIconHeaderPenalty,
      lastCalibratedAt: lastCalibratedAt ?? this.lastCalibratedAt,
      calibratedBy: calibratedBy ?? this.calibratedBy,
    );
  }
}
