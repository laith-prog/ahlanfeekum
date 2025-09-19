// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verification_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerificationResponse _$OtpVerificationResponseFromJson(
        Map<String, dynamic> json) =>
    OtpVerificationResponse(
      data: json['data'] as bool,
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$OtpVerificationResponseToJson(
        OtpVerificationResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'code': instance.code,
    };
