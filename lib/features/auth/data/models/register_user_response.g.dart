// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterUserResponse _$RegisterUserResponseFromJson(
        Map<String, dynamic> json) =>
    RegisterUserResponse(
      data: json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>),
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$RegisterUserResponseToJson(
        RegisterUserResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'code': instance.code,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      address: json['address'] as String,
      profilePhoto: json['profilePhoto'] as String,
      isSuperHost: json['isSuperHost'] as bool,
      roleId: json['roleId'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'profilePhoto': instance.profilePhoto,
      'isSuperHost': instance.isSuperHost,
      'roleId': instance.roleId,
    };
