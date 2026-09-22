class Profile {
  final String id;
  final String fullName;
  final String professionalTitle;
  final String email;
  final String phone;
  final String location;
  final String? linkedinUrl;
  final String? githubUrl;
  final String? portfolioUrl;
  final String? bio;
  final String? avatarUrl;

  const Profile({
    required this.id,
    required this.fullName,
    required this.professionalTitle,
    required this.email,
    required this.phone,
    required this.location,
    this.linkedinUrl,
    this.githubUrl,
    this.portfolioUrl,
    this.bio,
    this.avatarUrl,
  });

  Profile copyWith({
    String? id,
    String? fullName,
    String? professionalTitle,
    String? email,
    String? phone,
    String? location,
    String? linkedinUrl,
    String? githubUrl,
    String? portfolioUrl,
    String? bio,
    String? avatarUrl,
  }) {
    return Profile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      professionalTitle: professionalTitle ?? this.professionalTitle,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      githubUrl: githubUrl ?? this.githubUrl,
      portfolioUrl: portfolioUrl ?? this.portfolioUrl,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
