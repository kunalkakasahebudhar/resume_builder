class AdminResume {
  final String id;
  final String resumeName;
  final String userName;
  final String userEmail;
  final String templateName;
  final int atsScore;
  final String targetRole;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AdminResume({
    required this.id,
    required this.resumeName,
    required this.userName,
    required this.userEmail,
    required this.templateName,
    required this.atsScore,
    required this.targetRole,
    required this.createdAt,
    required this.updatedAt,
  });
}
