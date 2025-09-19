import 'package:json_annotation/json_annotation.dart';

part 'home_response.g.dart';

@JsonSerializable()
class HomeResponse {
  final List<SpecialAdvertisementDto> specialAdvertismentMobileDtos;
  final List<SiteProperty> siteProperties;
  final List<SiteProperty> highlyRatedProperty;
  final List<GovernorateDto> governorateMobileDto;
  final OnlyForYouSectionDto onlyForYouSectionMobileDto;

  const HomeResponse({
    required this.specialAdvertismentMobileDtos,
    required this.siteProperties,
    required this.highlyRatedProperty,
    required this.governorateMobileDto,
    required this.onlyForYouSectionMobileDto,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HomeResponseToJson(this);
}

@JsonSerializable()
class SpecialAdvertisementDto {
  final String id;
  final String image;
  final String sitePropertyId;
  final String sitePropertyTitle;

  const SpecialAdvertisementDto({
    required this.id,
    required this.image,
    required this.sitePropertyId,
    required this.sitePropertyTitle,
  });

  factory SpecialAdvertisementDto.fromJson(Map<String, dynamic> json) =>
      _$SpecialAdvertisementDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SpecialAdvertisementDtoToJson(this);
}

@JsonSerializable()
class SiteProperty {
  final String id;
  final String propertyTitle;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landMark;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final String? mainImage;

  const SiteProperty({
    required this.id,
    required this.propertyTitle,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    this.mainImage,
  });

  factory SiteProperty.fromJson(Map<String, dynamic> json) =>
      _$SitePropertyFromJson(json);

  Map<String, dynamic> toJson() => _$SitePropertyToJson(this);
}

@JsonSerializable()
class GovernorateDto {
  final String id;
  final String title;

  const GovernorateDto({
    required this.id,
    required this.title,
  });

  factory GovernorateDto.fromJson(Map<String, dynamic> json) =>
      _$GovernorateDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GovernorateDtoToJson(this);
}

@JsonSerializable()
class OnlyForYouSectionDto {
  final String id;
  final String firstPhoto;
  final String secondPhoto;
  final String thirdPhoto;

  const OnlyForYouSectionDto({
    required this.id,
    required this.firstPhoto,
    required this.secondPhoto,
    required this.thirdPhoto,
  });

  factory OnlyForYouSectionDto.fromJson(Map<String, dynamic> json) =>
      _$OnlyForYouSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OnlyForYouSectionDtoToJson(this);
}
