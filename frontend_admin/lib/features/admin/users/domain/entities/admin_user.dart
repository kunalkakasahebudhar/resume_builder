class AdminUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? linkedIn;
  final String? github;
  final String? portfolio;
  final int resumesCount;
  final String status; // 'Active', 'Inactive', 'Suspended'
  final DateTime createdAt;
  final DateTime lastActive;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.linkedIn,
    this.github,
    this.portfolio,
    this.resumesCount = 0,
    required this.status,
    required this.createdAt,
    required this.lastActive,
  });

  AdminUser copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? linkedIn,
    String? github,
    String? portfolio,
    int? resumesCount,
    String? status,
    DateTime? createdAt,
    DateTime? lastActive,
  }) {
    return AdminUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      linkedIn: linkedIn ?? this.linkedIn,
      github: github ?? this.github,
      portfolio: portfolio ?? this.portfolio,
      resumesCount: resumesCount ?? this.resumesCount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
