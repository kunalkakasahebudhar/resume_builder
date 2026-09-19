class Certification {
  final String id;
  final String name;
  final String issuingOrganization;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;
  final String? credentialUrl;

  const Certification({
    required this.id,
    required this.name,
    required this.issuingOrganization,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
  });

  Certification copyWith({
    String? id,
    String? name,
    String? issuingOrganization,
    String? issueDate,
    String? expiryDate,
    String? credentialId,
    String? credentialUrl,
  }) {
    return Certification(
      id: id ?? this.id,
      name: name ?? this.name,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
    );
  }
}
