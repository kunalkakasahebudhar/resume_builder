class Template {
  final String id;
  final String name;
  final String description;
  final String category; // 'Classic', 'Professional', 'Fresher', 'Experienced'
  final String status; // 'Active', 'Inactive'
  final int usageCount;
  final String previewColor;
  final DateTime createdAt;

  const Template({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.status,
    required this.usageCount,
    required this.previewColor,
    required this.createdAt,
  });

  Template copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? status,
    int? usageCount,
    String? previewColor,
    DateTime? createdAt,
  }) {
    return Template(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      usageCount: usageCount ?? this.usageCount,
      previewColor: previewColor ?? this.previewColor,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
