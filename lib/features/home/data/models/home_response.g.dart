// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
      specialAdvertismentMobileDtos:
          (json['specialAdvertismentMobileDtos'] as List<dynamic>)
              .map((e) =>
                  SpecialAdvertisementDto.fromJson(e as Map<String, dynamic>))
              .toList(),
      siteProperties: (json['siteProperties'] as List<dynamic>)
          .map((e) => SiteProperty.fromJson(e as Map<String, dynamic>))
          .toList(),
      highlyRatedProperty: (json['highlyRatedProperty'] as List<dynamic>)
          .map((e) => SiteProperty.fromJson(e as Map<String, dynamic>))
          .toList(),
      governorateMobileDto: (json['governorateMobileDto'] as List<dynamic>)
          .map((e) => GovernorateDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      onlyForYouSectionMobileDto: OnlyForYouSectionDto.fromJson(
          json['onlyForYouSectionMobileDto'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'specialAdvertismentMobileDtos': instance.specialAdvertismentMobileDtos,
      'siteProperties': instance.siteProperties,
      'highlyRatedProperty': instance.highlyRatedProperty,
      'governorateMobileDto': instance.governorateMobileDto,
      'onlyForYouSectionMobileDto': instance.onlyForYouSectionMobileDto,
    };

SpecialAdvertisementDto _$SpecialAdvertisementDtoFromJson(
        Map<String, dynamic> json) =>
    SpecialAdvertisementDto(
      id: json['id'] as String,
      image: json['image'] as String,
      sitePropertyId: json['sitePropertyId'] as String,
      sitePropertyTitle: json['sitePropertyTitle'] as String,
    );

Map<String, dynamic> _$SpecialAdvertisementDtoToJson(
        SpecialAdvertisementDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'sitePropertyId': instance.sitePropertyId,
      'sitePropertyTitle': instance.sitePropertyTitle,
    };

SiteProperty _$SitePropertyFromJson(Map<String, dynamic> json) => SiteProperty(
      id: json['id'] as String,
      propertyTitle: json['propertyTitle'] as String,
      hotelName: json['hotelName'] as String?,
      address: json['address'] as String?,
      streetAndBuildingNumber: json['streetAndBuildingNumber'] as String?,
      landMark: json['landMark'] as String?,
      pricePerNight: (json['pricePerNight'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      isFavorite: json['isFavorite'] as bool,
      mainImage: json['mainImage'] as String?,
    );

Map<String, dynamic> _$SitePropertyToJson(SiteProperty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'propertyTitle': instance.propertyTitle,
      'hotelName': instance.hotelName,
      'address': instance.address,
      'streetAndBuildingNumber': instance.streetAndBuildingNumber,
      'landMark': instance.landMark,
      'pricePerNight': instance.pricePerNight,
      'isActive': instance.isActive,
      'isFavorite': instance.isFavorite,
      'mainImage': instance.mainImage,
    };

GovernorateDto _$GovernorateDtoFromJson(Map<String, dynamic> json) =>
    GovernorateDto(
      id: json['id'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$GovernorateDtoToJson(GovernorateDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

OnlyForYouSectionDto _$OnlyForYouSectionDtoFromJson(
        Map<String, dynamic> json) =>
    OnlyForYouSectionDto(
      id: json['id'] as String,
      firstPhoto: json['firstPhoto'] as String,
      secondPhoto: json['secondPhoto'] as String,
      thirdPhoto: json['thirdPhoto'] as String,
    );

Map<String, dynamic> _$OnlyForYouSectionDtoToJson(
        OnlyForYouSectionDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstPhoto': instance.firstPhoto,
      'secondPhoto': instance.secondPhoto,
      'thirdPhoto': instance.thirdPhoto,
    };
