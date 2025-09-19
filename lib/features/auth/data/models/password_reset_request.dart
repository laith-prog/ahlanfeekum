import 'package:json_annotation/json_annotation.dart';

part 'password_reset_request.g.dart';

@JsonSerializable()
class PasswordResetRequest {
  final String emailOrPhone;

  const PasswordResetRequest({required this.emailOrPhone});

  factory PasswordResetRequest.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PasswordResetRequestToJson(this);
}
