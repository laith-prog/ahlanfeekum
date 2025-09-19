import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final LoginData? data;
  final String message;
  final int code;

  const LoginResponse({this.data, required this.message, required this.code});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class LoginData {
  @JsonKey(name: 'tokenType')
  final String? tokenType;

  @JsonKey(name: 'expiresIn')
  final String? expiresIn;

  @JsonKey(name: 'extExpiresIn')
  final String? extExpiresIn;

  @JsonKey(name: 'expiresOn')
  final String? expiresOn;

  @JsonKey(name: 'notBefore')
  final String? notBefore;

  final String? resource;

  @JsonKey(name: 'accessToken')
  final String? accessToken;

  final String? name;
  final String? phone;
  final String? email;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'roleId')
  final int? roleId;

  const LoginData({
    this.tokenType,
    this.expiresIn,
    this.extExpiresIn,
    this.expiresOn,
    this.notBefore,
    this.resource,
    this.accessToken,
    this.name,
    this.phone,
    this.email,
    this.userId,
    this.roleId,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
}
