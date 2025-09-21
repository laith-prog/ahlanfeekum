// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PropertyModel _$PropertyModelFromJson(Map<String, dynamic> json) =>
    PropertyModel(
      id: json['id'] as String?,
      propertyTitle: json['propertyTitle'] as String,
      hotelName: json['hotelName'] as String,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      numberOfBed: (json['numberOfBed'] as num).toInt(),
      floor: (json['floor'] as num).toInt(),
      maximumNumberOfGuest: (json['maximumNumberOfGuest'] as num).toInt(),
      livingrooms: (json['livingrooms'] as num).toInt(),
      propertyDescription: json['propertyDescription'] as String,
      houseRules: json['hourseRules'] as String,
      importantInformation: json['importantInformation'] as String,
      address: json['address'] as String,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String,
      landMark: json['landMark'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      propertyTypeId: json['propertyTypeId'] as String,
      governorateId: json['governorateId'] as String,
      propertyFeatureIds: (json['propertyFeatureIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PropertyModelToJson(PropertyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'numberOfBed': instance.numberOfBed,
      'floor': instance.floor,
      'maximumNumberOfGuest': instance.maximumNumberOfGuest,
      'livingrooms': instance.livingrooms,
      'propertyDescription': instance.propertyDescription,
      'hourseRules': instance.houseRules,
      'importantInformation': instance.importantInformation,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'pricePerNight': instance.pricePerNight,
      'isActive': instance.isActive,
      'propertyTypeId': instance.propertyTypeId,
      'governorateId': instance.governorateId,
      'propertyFeatureIds': instance.propertyFeatureIds,
    };
