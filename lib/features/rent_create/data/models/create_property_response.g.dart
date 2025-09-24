// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_property_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePropertyResponse _$CreatePropertyResponseFromJson(
        Map<String, dynamic> json) =>
    CreatePropertyResponse(
      propertyTitle: json['propertyTitle'] as String?,
      hotelName: json['hotelName'] as String?,
      bedrooms: (json['bedrooms'] as num?)?.toInt(),
      bathrooms: (json['bathrooms'] as num?)?.toInt(),
      numberOfBed: (json['numberOfBed'] as num?)?.toInt(),
      floor: (json['floor'] as num?)?.toInt(),
      maximumNumberOfGuest: (json['maximumNumberOfGuest'] as num?)?.toInt(),
      livingrooms: (json['livingrooms'] as num?)?.toInt(),
      propertyDescription: json['propertyDescription'] as String?,
      hourseRules: json['hourseRules'] as String?,
      importantInformation: json['importantInformation'] as String?,
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      pricePerNight: (json['pricePerNight'] as num?)?.toInt(),
      area: (json['area'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool?,
      propertyTypeId: json['propertyTypeId'] as String?,
      governorateId: json['governorateId'] as String?,
      ownerId: json['ownerId'] as String?,
      statusId: json['statusId'] as String?,
      concurrencyStamp: json['concurrencyStamp'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      deleterId: json['deleterId'] as String?,
      deletionTime: json['deletionTime'] as String?,
      lastModificationTime: json['lastModificationTime'] as String?,
      lastModifierId: json['lastModifierId'] as String?,
      creationTime: json['creationTime'] as String?,
      creatorId: json['creatorId'] as String?,
      id: json['id'] as String,
    );

Map<String, dynamic> _$CreatePropertyResponseToJson(
        CreatePropertyResponse instance) =>
    <String, dynamic>{
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'numberOfBed': instance.numberOfBed,
      'floor': instance.floor,
      'maximumNumberOfGuest': instance.maximumNumberOfGuest,
      'livingrooms': instance.livingrooms,
      'propertyDescription': instance.propertyDescription,
      'hourseRules': instance.hourseRules,
      'importantInformation': instance.importantInformation,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'pricePerNight': instance.pricePerNight,
      'area': instance.area,
      'isActive': instance.isActive,
      'propertyTypeId': instance.propertyTypeId,
      'governorateId': instance.governorateId,
      'ownerId': instance.ownerId,
      'statusId': instance.statusId,
      'concurrencyStamp': instance.concurrencyStamp,
      'isDeleted': instance.isDeleted,
      'deleterId': instance.deleterId,
      'deletionTime': instance.deletionTime,
      'lastModificationTime': instance.lastModificationTime,
      'lastModifierId': instance.lastModifierId,
      'creationTime': instance.creationTime,
      'creatorId': instance.creatorId,
      'id': instance.id,
    };

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ApiResponse<T>(
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String,
      code: (json['code'] as num).toInt(),
    );

Map<String, dynamic> _$ApiResponseToJson<T>(
  ApiResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': _$nullableGenericToJson(instance.data, toJsonT),
      'message': instance.message,
      'code': instance.code,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
