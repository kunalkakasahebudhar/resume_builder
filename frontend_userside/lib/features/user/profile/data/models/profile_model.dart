import 'package:frontend_userside/features/user/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.professionalTitle,
    required super.email,
    required super.phone,
    required super.location,
    super.linkedinUrl,
    super.githubUrl,
    super.portfolioUrl,
    super.bio,
    super.avatarUrl,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      fullName:
          json['full_name'] as String? ?? json['fullName'] as String? ?? '',
      professionalTitle:
          json['professional_title'] as String? ??
          json['professionalTitle'] as String? ??
          '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      location: json['location'] as String? ?? '',
      linkedinUrl:
          json['linkedin_url'] as String? ?? json['linkedinUrl'] as String?,
      githubUrl: json['github_url'] as String? ?? json['githubUrl'] as String?,
      portfolioUrl:
          json['portfolio_url'] as String? ?? json['portfolioUrl'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'professional_title': professionalTitle,
      'email': email,
      'phone': phone,
      'location': location,
      'linkedin_url': linkedinUrl,
      'github_url': githubUrl,
      'portfolio_url': portfolioUrl,
      'bio': bio,
      'avatar_url': avatarUrl,
    };
  }

  factory ProfileModel.fromEntity(Profile profile) {
    return ProfileModel(
      id: profile.id,
      fullName: profile.fullName,
      professionalTitle: profile.professionalTitle,
      email: profile.email,
      phone: profile.phone,
      location: profile.location,
      linkedinUrl: profile.linkedinUrl,
      githubUrl: profile.githubUrl,
      portfolioUrl: profile.portfolioUrl,
      bio: profile.bio,
      avatarUrl: profile.avatarUrl,
    );
  }
}
