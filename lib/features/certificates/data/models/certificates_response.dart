import 'package:json_annotation/json_annotation.dart';

part 'certificates_response.g.dart';

@JsonSerializable()
class CertificatesResponse {
  @JsonKey(defaultValue: <Certificate>[])
  final List<Certificate> data;

  final CertificatesPaginationMeta meta;

  CertificatesResponse({required this.data, required this.meta});

  factory CertificatesResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificatesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatesResponseToJson(this);
}

@JsonSerializable()
class CertificatesPaginationMeta {
  @JsonKey(name: 'current_page')
  final int currentPage;

  @JsonKey(name: 'per_page')
  final int perPage;

  final int total;

  CertificatesPaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
  });

  factory CertificatesPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$CertificatesPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatesPaginationMetaToJson(this);
}

@JsonSerializable()
class CertificateResponse {
  final Certificate data;

  CertificateResponse({required this.data});

  factory CertificateResponse.fromJson(Map<String, dynamic> json) =>
      _$CertificateResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateResponseToJson(this);
}

@JsonSerializable(includeIfNull: false)
class CertificateVerificationResponse {
  final bool valid;

  @JsonKey(name: 'certificate_code')
  final String? certificateCode;

  @JsonKey(name: 'issued_at')
  final String? issuedAt;

  CertificateVerificationResponse({
    required this.valid,
    this.certificateCode,
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
  final String? qrCodeData;

  @JsonKey(name: 'digital_signature')
  final String? digitalSignature;

  @JsonKey(name: 'certificate_metadata')
  final Map<String, dynamic>? certificateMetadata;

  @JsonKey(name: 'issued_at')
  final String? issuedAt;

  @JsonKey(name: 'expires_at')
  final String? expiresAt;

  @JsonKey(name: 'verification_status')
  final String verificationStatus;

  @JsonKey(name: 'additional_credentials')
  final Map<String, dynamic>? additionalCredentials;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  Certificate({
    required this.certificateId,
    required this.candidateUserId,
    required this.assessmentResultId,
    required this.examId,
    required this.tenantId,
    required this.certificateCode,
    this.qrCodeData,
    this.digitalSignature,
    this.certificateMetadata,
    this.issuedAt,
    this.expiresAt,
    required this.verificationStatus,
    this.additionalCredentials,
    this.createdAt,
  });

  bool get isRevoked => verificationStatus.toLowerCase() == 'revoked';

  String? get revokedAt {
    final value = certificateMetadata?['revoked_at'];
    return value is String && value.isNotEmpty ? value : null;
  }

  String? get revokedReason {
    final value = certificateMetadata?['revoked_reason'];
    return value is String && value.isNotEmpty ? value : null;
  }

  Certificate copyWith({String? verificationStatus}) {
    return Certificate(
      certificateId: certificateId,
      candidateUserId: candidateUserId,
      assessmentResultId: assessmentResultId,
      examId: examId,
      tenantId: tenantId,
      certificateCode: certificateCode,
      qrCodeData: qrCodeData,
      digitalSignature: digitalSignature,
      certificateMetadata: certificateMetadata,
      issuedAt: issuedAt,
      expiresAt: expiresAt,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      additionalCredentials: additionalCredentials,
      createdAt: createdAt,
    );
  }

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateToJson(this);
}

class CertificateDownloadFile {
  final String filePath;
  final String fileName;
  final int bytesLength;

  const CertificateDownloadFile({
    required this.filePath,
    required this.fileName,
    required this.bytesLength,
  });
}
