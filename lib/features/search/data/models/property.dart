import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String id;
  final String title;
  final String description;
  final double pricePerNight;
  final String address;
  final String? cityName;
  final String? governateName;
  final int bedrooms;
  final int bathrooms;
  final int livingrooms;
  final double rating;
  final List<String> images;
  final List<String> features;
  final String propertyTypeId;
  final String? propertyTypeName;
  final String? hotelName;
  final bool isActive;
  final DateTime? createdDate;

  const Property({
    required this.id,
    required this.title,
    required this.description,
    required this.pricePerNight,
    required this.address,
    this.cityName,
    this.governateName,
    required this.bedrooms,
    required this.bathrooms,
    required this.livingrooms,
    required this.rating,
    required this.images,
    required this.features,
    required this.propertyTypeId,
    this.propertyTypeName,
    this.hotelName,
    required this.isActive,
    this.createdDate,
  });

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);
}

@JsonSerializable()
class PropertySearchResponse {
  final List<Property> items;
  final int totalCount;

  const PropertySearchResponse({
    required this.items,
    required this.totalCount,
  });

  factory PropertySearchResponse.fromJson(Map<String, dynamic> json) =>
      _$PropertySearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PropertySearchResponseToJson(this);
}

