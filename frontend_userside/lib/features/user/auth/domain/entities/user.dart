class User {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.createdAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          fullName == other.fullName;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ fullName.hashCode;
}
