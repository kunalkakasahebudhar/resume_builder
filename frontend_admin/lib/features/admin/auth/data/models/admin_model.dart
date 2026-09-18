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
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'Admin',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory AdminModel.fromJsonString(String jsonString) =>
      AdminModel.fromJson(jsonDecode(jsonString) as Map<String, dynamic>);
}
