import 'package:json_annotation/json_annotation.dart';

part 'create_property_response.g.dart';

@JsonSerializable()
class CreatePropertyResponse {
  final String? propertyTitle;
  final String? hotelName;
  final int? bedrooms;
  final int? bathrooms;
  final int? numberOfBed;
  final int? floor;
  final int? maximumNumberOfGuest;
  final int? livingrooms;
  final String? propertyDescription;
  final String? hourseRules;
  final String? importantInformation;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final int? pricePerNight;
  final double? area;
  final bool? isActive;
  final String? propertyTypeId;
  final String? governorateId;
  final String? ownerId;
  final String? statusId;
  final String? concurrencyStamp;
  final bool? isDeleted;
  final String? deleterId;
  final String? deletionTime;
  final String? lastModificationTime;
  final String? lastModifierId;
  final String? creationTime;
  final String? creatorId;
  final String id;

  const CreatePropertyResponse({
    this.propertyTitle,
    this.hotelName,
    this.bedrooms,
    this.bathrooms,
    this.numberOfBed,
    this.floor,
    this.maximumNumberOfGuest,
    this.livingrooms,
    this.propertyDescription,
    this.hourseRules,
    this.importantInformation,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.pricePerNight,
    this.area,
    this.isActive,
    this.propertyTypeId,
    this.governorateId,
    this.ownerId,
    this.statusId,
    this.concurrencyStamp,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.lastModificationTime,
    this.lastModifierId,
    this.creationTime,
    this.creatorId,
    required this.id,
  });

  factory CreatePropertyResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePropertyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePropertyResponseToJson(this);
}

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final T? data;
  final String message;
  final int code;

  const ApiResponse({
    this.data,
    required this.message,
    required this.code,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => 
      _$ApiResponseToJson(this, toJsonT);
}
