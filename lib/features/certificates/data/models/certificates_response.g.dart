// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificatesResponse _$CertificatesResponseFromJson(
  Map<String, dynamic> json,
) => CertificatesResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => Certificate.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CertificatesResponseToJson(
  CertificatesResponse instance,
) => <String, dynamic>{'data': instance.data};

CertificateResponse _$CertificateResponseFromJson(Map<String, dynamic> json) =>
    CertificateResponse(
      data: Certificate.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CertificateResponseToJson(
  CertificateResponse instance,
) => <String, dynamic>{'data': instance.data};

CertificateVerificationResponse _$CertificateVerificationResponseFromJson(
  Map<String, dynamic> json,
) => CertificateVerificationResponse(
  valid: json['valid'] as bool,
  certificateCode: json['certificate_code'] as String,
  issuedAt: json['issued_at'] as String?,
);

Map<String, dynamic> _$CertificateVerificationResponseToJson(
  CertificateVerificationResponse instance,
) => <String, dynamic>{
  'valid': instance.valid,
  'certificate_code': instance.certificateCode,
  'issued_at': instance.issuedAt,
};

Certificate _$CertificateFromJson(Map<String, dynamic> json) => Certificate(
  certificateId: json['certificate_id'] as String,
  candidateUserId: json['candidate_user_id'] as String,
  assessmentResultId: json['assessment_result_id'] as String,
  examId: json['exam_id'] as String,
  tenantId: json['tenant_id'] as String,
  certificateCode: json['certificate_code'] as String,
  qrCodeData: json['qr_code_data'] as String,
  issuedAt: json['issued_at'] as String,
  expiresAt: json['expires_at'] as String?,
  verificationStatus: json['verification_status'] as String,
  revokedAt: json['revoked_at'] as String?,
  revocationReason: json['revocation_reason'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$CertificateToJson(Certificate instance) =>
    <String, dynamic>{
      'certificate_id': instance.certificateId,
      'candidate_user_id': instance.candidateUserId,
      'assessment_result_id': instance.assessmentResultId,
      'exam_id': instance.examId,
      'tenant_id': instance.tenantId,
      'certificate_code': instance.certificateCode,
      'qr_code_data': instance.qrCodeData,
      'issued_at': instance.issuedAt,
      'expires_at': instance.expiresAt,
      'verification_status': instance.verificationStatus,
      'revoked_at': instance.revokedAt,
      'revocation_reason': instance.revocationReason,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
