import 'package:json_annotation/json_annotation.dart';

part 'otp_verification_response.g.dart';

@JsonSerializable()
class OtpVerificationResponse {
  final bool data;
  final String message;
  final int code;

  const OtpVerificationResponse({
    required this.data,
    required this.message,
    required this.code,
  });

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) =>
      _$OtpVerificationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerificationResponseToJson(this);
}
