// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      id: json['id'] as String,
      title: json['propertyTitle'] as String,
      description: json['streetAndBuildingNumber'] as String?,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      address: json['address'] as String?,
      cityName: json['cityName'] as String?,
      governateName: json['governateName'] as String?,
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 1,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 1,
      livingrooms: (json['livingrooms'] as num?)?.toInt() ?? 1,
      rating: (json['averageRating'] as num?)?.toDouble(),
      mainImage: json['mainImage'] as String?,
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      propertyTypeId: json['propertyTypeId'] as String? ?? '',
      propertyTypeName: json['propertyTypeName'] as String?,
      hotelName: json['hotelName'] as String?,
      isActive: json['isActive'] as bool,
      landMark: json['landMark'] as String?,
      area: (json['area'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool?,
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.title,
      'streetAndBuildingNumber': instance.description,
      'pricePerNight': instance.pricePerNight,
      'address': instance.address,
      'cityName': instance.cityName,
      'governateName': instance.governateName,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'livingrooms': instance.livingrooms,
      'averageRating': instance.rating,
      'mainImage': instance.mainImage,
      'features': instance.features,
      'propertyTypeId': instance.propertyTypeId,
      'propertyTypeName': instance.propertyTypeName,
      'hotelName': instance.hotelName,
      'isActive': instance.isActive,
      'landMark': instance.landMark,
      'area': instance.area,
      'isFavorite': instance.isFavorite,
    };

PropertySearchResponse _$PropertySearchResponseFromJson(
        Map<String, dynamic> json) =>
    PropertySearchResponse(
      items: (json['items'] as List<dynamic>)
          .map((e) => Property.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
    );

Map<String, dynamic> _$PropertySearchResponseToJson(
        PropertySearchResponse instance) =>
    <String, dynamic>{
      'items': instance.items,
      'totalCount': instance.totalCount,
    };
