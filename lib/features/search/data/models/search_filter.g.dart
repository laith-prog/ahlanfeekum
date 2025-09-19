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
      pricePerNightMin: (json['pricePerNightMin'] as num?)?.toDouble(),
      pricePerNightMax: (json['pricePerNightMax'] as num?)?.toDouble(),
      address: json['address'] as String?,
      bathroomsMin: (json['bathroomsMin'] as num?)?.toInt(),
      bathroomsMax: (json['bathroomsMax'] as num?)?.toInt(),
      hotelName: json['hotelName'] as String?,
      livingroomsMin: (json['livingroomsMin'] as num?)?.toInt(),
      livingroomsMax: (json['livingroomsMax'] as num?)?.toInt(),
      isActive: json['isActive'] as bool? ?? true,
      skipCount: (json['skipCount'] as num?)?.toInt() ?? 0,
      maxResultCount: (json['maxResultCount'] as num?)?.toInt() ?? 20,
      selectedFeatures: (json['selectedFeatures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      governateId: json['governateId'] as String?,
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
      'bathroomsMin': instance.bathroomsMin,
      'bathroomsMax': instance.bathroomsMax,
      'hotelName': instance.hotelName,
      'livingroomsMin': instance.livingroomsMin,
      'livingroomsMax': instance.livingroomsMax,
      'isActive': instance.isActive,
      'skipCount': instance.skipCount,
      'maxResultCount': instance.maxResultCount,
      'selectedFeatures': instance.selectedFeatures,
      'governateId': instance.governateId,
    };
