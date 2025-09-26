import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  final String id;
  @JsonKey(name: 'propertyTitle')
  final String title;
  @JsonKey(name: 'streetAndBuildingNumber')
  final String? description;
  final double pricePerNight;
  final String? address;
  final String? cityName;
  final String? governateName;
  @JsonKey(defaultValue: 1)
  final int bedrooms;
  @JsonKey(defaultValue: 1)
  final int bathrooms;
  @JsonKey(defaultValue: 1)
  final int livingrooms;
  @JsonKey(name: 'averageRating')
  final double? rating;
  @JsonKey(name: 'mainImage')
  final String? mainImage;
  @JsonKey(defaultValue: <String>[])
  final List<String> features;
  @JsonKey(defaultValue: '')
  final String propertyTypeId;
  final String? propertyTypeName;
  final String? hotelName;
  final bool isActive;
  final String? landMark;
  final int? area;
  final bool? isFavorite;

  const Property({
    required this.id,
    required this.title,
    this.description,
    required this.pricePerNight,
    this.address,
    this.cityName,
    this.governateName,
    required this.bedrooms,
    required this.bathrooms,
    required this.livingrooms,
    this.rating,
    this.mainImage,
    required this.features,
    required this.propertyTypeId,
    this.propertyTypeName,
    this.hotelName,
    required this.isActive,
    this.landMark,
    this.area,
    this.isFavorite,
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

