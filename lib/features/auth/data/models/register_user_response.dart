import 'package:json_annotation/json_annotation.dart';

part 'register_user_response.g.dart';

@JsonSerializable()
class RegisterUserResponse {
  final UserData? data;
  final String message;
  final int code;

  const RegisterUserResponse({
    this.data,
    required this.message,
    required this.code,
  });

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserResponseToJson(this);
}

@JsonSerializable()
class UserData {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String latitude;
  final String longitude;
  final String address;
  final String profilePhoto;
  final bool isSuperHost;
  final String roleId;

  const UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.profilePhoto,
    required this.isSuperHost,
    required this.roleId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
