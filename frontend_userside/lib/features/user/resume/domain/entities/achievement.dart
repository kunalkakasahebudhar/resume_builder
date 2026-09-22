class Achievement {
  final String id;
  final String title;
  final String description;
  final String date;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? date,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
    );
  }
}
