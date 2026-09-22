import 'package:frontend_userside/features/user/resume/domain/entities/certification.dart';

class CertificationModel extends Certification {
  const CertificationModel({
    required super.id,
    required super.name,
    required super.issuingOrganization,
    required super.issueDate,
    super.expiryDate,
    super.credentialId,
    super.credentialUrl,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    return CertificationModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      issuingOrganization:
          json['issuing_organization'] as String? ??
          json['issuingOrganization'] as String? ??
          '',
      issueDate:
          json['issue_date'] as String? ?? json['issueDate'] as String? ?? '',
      expiryDate:
          json['expiry_date'] as String? ?? json['expiryDate'] as String?,
      credentialId:
          json['credential_id'] as String? ?? json['credentialId'] as String?,
      credentialUrl:
          json['credential_url'] as String? ?? json['credentialUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'issuing_organization': issuingOrganization,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'credential_id': credentialId,
      'credential_url': credentialUrl,
    };
  }

  factory CertificationModel.fromEntity(Certification c) {
    return CertificationModel(
      id: c.id,
      name: c.name,
      issuingOrganization: c.issuingOrganization,
      issueDate: c.issueDate,
      expiryDate: c.expiryDate,
      credentialId: c.credentialId,
      credentialUrl: c.credentialUrl,
    );
  }
}
