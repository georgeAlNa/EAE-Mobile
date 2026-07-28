// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificates_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificatesRequestBody _$CertificatesRequestBodyFromJson(
  Map<String, dynamic> json,
) => CertificatesRequestBody();

Map<String, dynamic> _$CertificatesRequestBodyToJson(
  CertificatesRequestBody instance,
) => <String, dynamic>{};

RevokeCertificateRequestBody _$RevokeCertificateRequestBodyFromJson(
  Map<String, dynamic> json,
) => RevokeCertificateRequestBody(reason: json['reason'] as String);

Map<String, dynamic> _$RevokeCertificateRequestBodyToJson(
  RevokeCertificateRequestBody instance,
) => <String, dynamic>{'reason': instance.reason};
