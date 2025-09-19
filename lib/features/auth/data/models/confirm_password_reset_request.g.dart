// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_password_reset_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmPasswordResetRequest _$ConfirmPasswordResetRequestFromJson(
        Map<String, dynamic> json) =>
    ConfirmPasswordResetRequest(
      emailOrPhone: json['emailOrPhone'] as String,
      securityCode: json['securityCode'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$ConfirmPasswordResetRequestToJson(
        ConfirmPasswordResetRequest instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
      'securityCode': instance.securityCode,
      'newPassword': instance.newPassword,
    };
