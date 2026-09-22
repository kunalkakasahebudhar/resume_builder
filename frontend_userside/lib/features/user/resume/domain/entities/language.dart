class Language {
  final String id;
  final String language;
  final String proficiency; // Beginner, Intermediate, Advanced, Fluent, Native

  const Language({
    required this.id,
    required this.language,
    this.proficiency = 'Fluent',
  });

  Language copyWith({String? id, String? language, String? proficiency}) {
    return Language(
      id: id ?? this.id,
      language: language ?? this.language,
      proficiency: proficiency ?? this.proficiency,
    );
  }
}
