import 'package:json_annotation/json_annotation.dart';

part 'certificates_response.g.dart';

@JsonSerializable()
class CertificatesResponse {
  final List<Certificate> data;

  CertificatesResponse({required this.data});

  factory CertificatesResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatesResponseToJson(this);
}

@JsonSerializable()
class CertificateResponse {
  final Certificate data;

  CertificateResponse({required this.data});

  factory CertificateResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateResponseToJson(this);
}

@JsonSerializable()
class CertificateVerificationResponse {
  final bool valid;

  @JsonKey(name: 'certificate_code')
  final String certificateCode;

  @JsonKey(name: 'issued_at')
  final String? issuedAt;

  CertificateVerificationResponse({
    required this.valid,
    required this.certificateCode,
    this.issuedAt,
  });

  factory CertificateVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CertificateVerificationResponseToJson(this);
}

@JsonSerializable()
class Certificate {
  @JsonKey(name: 'certificate_id')
  final String certificateId;

  @JsonKey(name: 'candidate_user_id')
  final String candidateUserId;

  @JsonKey(name: 'assessment_result_id')
  final String assessmentResultId;

  @JsonKey(name: 'exam_id')
  final String examId;

  @JsonKey(name: 'tenant_id')
  final String tenantId;

  @JsonKey(name: 'certificate_code')
  final String certificateCode;

  @JsonKey(name: 'qr_code_data')
  final String qrCodeData;

  @JsonKey(name: 'issued_at')
  final String issuedAt;

  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  @JsonKey(name: 'verification_status')
  final String verificationStatus;

  @JsonKey(name: 'revoked_at')
  final String? revokedAt;

  @JsonKey(name: 'revocation_reason')
  final String? revocationReason;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Certificate({
    required this.certificateId,
    required this.candidateUserId,
    required this.assessmentResultId,
    required this.examId,
    required this.tenantId,
    required this.certificateCode,
    required this.qrCodeData,
    required this.issuedAt,
    this.expiresAt,
    required this.verificationStatus,
    this.revokedAt,
    this.revocationReason,
    this.createdAt,
    this.updatedAt,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateToJson(this);
}
