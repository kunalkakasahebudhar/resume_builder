class Admin {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? avatarUrl;
  final DateTime? createdAt;

  const Admin({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.avatarUrl,
    this.createdAt,
  });
}
