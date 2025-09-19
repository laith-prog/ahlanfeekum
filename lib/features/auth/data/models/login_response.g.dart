// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      data: json['data'] == null
          ? null
          : LoginData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'code': instance.code,
    };

LoginData _$LoginDataFromJson(Map<String, dynamic> json) => LoginData(
      tokenType: json['tokenType'] as String?,
      expiresIn: json['expiresIn'] as String?,
      extExpiresIn: json['extExpiresIn'] as String?,
      expiresOn: json['expiresOn'] as String?,
      notBefore: json['notBefore'] as String?,
      resource: json['resource'] as String?,
      accessToken: json['accessToken'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      userId: json['userId'] as String?,
      roleId: (json['roleId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LoginDataToJson(LoginData instance) => <String, dynamic>{
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
      'extExpiresIn': instance.extExpiresIn,
      'expiresOn': instance.expiresOn,
      'notBefore': instance.notBefore,
      'resource': instance.resource,
      'accessToken': instance.accessToken,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'userId': instance.userId,
      'roleId': instance.roleId,
    };
