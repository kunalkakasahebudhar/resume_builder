import 'dart:convert';
import 'package:frontend_admin/features/admin/auth/domain/entities/admin.dart';

class AdminModel extends Admin {
  const AdminModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.phone,
    super.avatarUrl,
    super.createdAt,
    super.lastLoginAt,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as String? ?? 'admin-1',
      name: json['name'] as String? ?? 'Alex Morgan',
      email: json['email'] as String? ?? 'admin@resumeforge.com',
      role: AdminRole.fromString(json['role'] as String?),
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : DateTime.now().subtract(const Duration(days: 90)),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.tryParse(json['last_login_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.label,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory AdminModel.fromJsonString(String jsonString) =>
      AdminModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
