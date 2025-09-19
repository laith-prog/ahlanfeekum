import 'package:json_annotation/json_annotation.dart';

part 'confirm_password_reset_request.g.dart';

@JsonSerializable()
class ConfirmPasswordResetRequest {
  final String emailOrPhone;
  final String securityCode;
  final String newPassword;

  const ConfirmPasswordResetRequest({
    required this.emailOrPhone,
    required this.securityCode,
    required this.newPassword,
  });

  factory ConfirmPasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$ConfirmPasswordResetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ConfirmPasswordResetRequestToJson(this);
}
