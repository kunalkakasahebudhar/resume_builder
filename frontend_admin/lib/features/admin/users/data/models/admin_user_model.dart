import 'package:frontend_admin/features/admin/users/domain/entities/admin_user.dart';

class AdminUserModel extends AdminUser {
  const AdminUserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.linkedIn,
    super.github,
    super.portfolio,
    super.resumesCount,
    required super.status,
    required super.createdAt,
    required super.lastActive,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      linkedIn: json['linkedin'] as String?,
      github: json['github'] as String?,
      portfolio: json['portfolio'] as String?,
      resumesCount: json['resumes_count'] as int? ?? 0,
      status: json['status'] as String? ?? 'Active',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      lastActive: json['last_active'] != null
          ? DateTime.tryParse(json['last_active'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'linkedin': linkedIn,
      'github': github,
      'portfolio': portfolio,
      'resumes_count': resumesCount,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'last_active': lastActive.toIso8601String(),
    };
  }
}
