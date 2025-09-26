// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchFilter _$SearchFilterFromJson(Map<String, dynamic> json) => SearchFilter(
      filterText: json['filterText'] as String?,
      propertyTypeId: json['propertyTypeId'] as String?,
      checkInDate: (json['checkInDate'] as num?)?.toInt(),
      checkOutDate: (json['checkOutDate'] as num?)?.toInt(),
      pricePerNightMin: (json['pricePerNightMin'] as num?)?.toInt(),
      pricePerNightMax: (json['pricePerNightMax'] as num?)?.toInt(),
      address: json['address'] as String?,
      bedroomsMin: (json['bedroomsMin'] as num?)?.toInt(),
      bedroomsMax: (json['bedroomsMax'] as num?)?.toInt(),
      bathroomsMin: (json['bathroomsMin'] as num?)?.toInt(),
      bathroomsMax: (json['bathroomsMax'] as num?)?.toInt(),
      numberOfBedMin: (json['numberOfBedMin'] as num?)?.toInt(),
      numberOfBedMax: (json['numberOfBedMax'] as num?)?.toInt(),
      governorateId: json['governorateId'] as String?,
      hotelName: json['hotelName'] as String?,
      maximumNumberOfGuestMin:
          (json['maximumNumberOfGuestMin'] as num?)?.toInt(),
      maximumNumberOfGuestMax:
          (json['maximumNumberOfGuestMax'] as num?)?.toInt(),
      livingroomsMin: (json['livingroomsMin'] as num?)?.toInt(),
      livingroomsMax: (json['livingroomsMax'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isActive: json['isActive'] as bool? ?? true,
      skipCount: (json['skipCount'] as num?)?.toInt() ?? 0,
      maxResultCount: (json['maxResultCount'] as num?)?.toInt() ?? 20,
      selectedFeatures: (json['selectedFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$SearchFilterToJson(SearchFilter instance) =>
    <String, dynamic>{
      'filterText': instance.filterText,
      'propertyTypeId': instance.propertyTypeId,
      'checkInDate': instance.checkInDate,
      'checkOutDate': instance.checkOutDate,
      'pricePerNightMin': instance.pricePerNightMin,
      'pricePerNightMax': instance.pricePerNightMax,
      'address': instance.address,
      'bedroomsMin': instance.bedroomsMin,
      'bedroomsMax': instance.bedroomsMax,
      'bathroomsMin': instance.bathroomsMin,
      'bathroomsMax': instance.bathroomsMax,
      'numberOfBedMin': instance.numberOfBedMin,
      'numberOfBedMax': instance.numberOfBedMax,
      'governorateId': instance.governorateId,
      'hotelName': instance.hotelName,
      'maximumNumberOfGuestMin': instance.maximumNumberOfGuestMin,
      'maximumNumberOfGuestMax': instance.maximumNumberOfGuestMax,
      'livingroomsMin': instance.livingroomsMin,
      'livingroomsMax': instance.livingroomsMax,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'isActive': instance.isActive,
      'skipCount': instance.skipCount,
      'maxResultCount': instance.maxResultCount,
      'selectedFeatures': instance.selectedFeatures,
    };
