// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetRequest _$PasswordResetRequestFromJson(
        Map<String, dynamic> json) =>
    PasswordResetRequest(
      emailOrPhone: json['emailOrPhone'] as String,
    );

Map<String, dynamic> _$PasswordResetRequestToJson(
        PasswordResetRequest instance) =>
    <String, dynamic>{
      'emailOrPhone': instance.emailOrPhone,
    };
