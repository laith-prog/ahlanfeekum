// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) => Property(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      address: json['address'] as String,
      cityName: json['cityName'] as String?,
      governateName: json['governateName'] as String?,
      bedrooms: (json['bedrooms'] as num).toInt(),
      bathrooms: (json['bathrooms'] as num).toInt(),
      livingrooms: (json['livingrooms'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      propertyTypeId: json['propertyTypeId'] as String,
      propertyTypeName: json['propertyTypeName'] as String?,
      hotelName: json['hotelName'] as String?,
      isActive: json['isActive'] as bool,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'pricePerNight': instance.pricePerNight,
      'address': instance.address,
      'cityName': instance.cityName,
      'governateName': instance.governateName,
      'bedrooms': instance.bedrooms,
      'bathrooms': instance.bathrooms,
      'livingrooms': instance.livingrooms,
      'rating': instance.rating,
      'images': instance.images,
      'features': instance.features,
      'propertyTypeId': instance.propertyTypeId,
      'propertyTypeName': instance.propertyTypeName,
      'hotelName': instance.hotelName,
      'isActive': instance.isActive,
      'createdDate': instance.createdDate?.toIso8601String(),
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
