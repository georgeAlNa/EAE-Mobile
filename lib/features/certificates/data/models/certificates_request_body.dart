import 'package:json_annotation/json_annotation.dart';

part 'certificates_request_body.g.dart';

@JsonSerializable()
class CertificatesRequestBody {
  CertificatesRequestBody();

  factory CertificatesRequestBody.fromJson(Map<String, dynamic> json) =>
      _$CertificatesRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$CertificatesRequestBodyToJson(this);
}

@JsonSerializable()
class RevokeCertificateRequestBody {
  final String reason;

  RevokeCertificateRequestBody({required this.reason});

  factory RevokeCertificateRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RevokeCertificateRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RevokeCertificateRequestBodyToJson(this);
}
