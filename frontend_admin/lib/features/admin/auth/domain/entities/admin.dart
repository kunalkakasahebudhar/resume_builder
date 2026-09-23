enum AdminRole {
  superAdmin('Super Admin'),
  contentModerator('Content Moderator'),
  supportAgent('Support Agent'),
  analyst('Analyst');

  final String label;
  const AdminRole(this.label);

  String get displayName => label;

  static AdminRole fromString(String? role) {
    if (role == null) return AdminRole.superAdmin;
    final r = role.toLowerCase().replaceAll(' ', '_').replaceAll('-', '_');
    if (r.contains('moderator')) return AdminRole.contentModerator;
    if (r.contains('support')) return AdminRole.supportAgent;
    if (r.contains('analyst')) return AdminRole.analyst;
    return AdminRole.superAdmin;
  }
}

class Admin {
  final String id;
  final String name;
  final String email;
  final AdminRole role;
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  const Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatarUrl,
    this.createdAt,
    this.lastLoginAt,
  });

  bool get isSuperAdmin => role == AdminRole.superAdmin;
  bool get canManageUsers =>
      role == AdminRole.superAdmin || role == AdminRole.supportAgent;
  bool get canModerateContent =>
      role == AdminRole.superAdmin || role == AdminRole.contentModerator;
  bool get canManageTemplates =>
      role == AdminRole.superAdmin || role == AdminRole.contentModerator;
  bool get canManageBilling =>
      role == AdminRole.superAdmin || role == AdminRole.supportAgent;
  bool get canConfigureAi => role == AdminRole.superAdmin;
  bool get canManageSettings => role == AdminRole.superAdmin;
  bool get canViewAnalytics => true;

  Admin copyWith({
    String? id,
    String? name,
    String? email,
    AdminRole? role,
    String? phone,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return Admin(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}
