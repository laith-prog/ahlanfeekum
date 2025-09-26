import 'package:json_annotation/json_annotation.dart';

part 'search_filter.g.dart';

@JsonSerializable()
class SearchFilter {
  final String? filterText;
  final String? propertyTypeId;
  final int? checkInDate;
  final int? checkOutDate;
  final int? pricePerNightMin;
  final int? pricePerNightMax;
  final String? address;
  final int? bedroomsMin;
  final int? bedroomsMax;
  final int? bathroomsMin;
  final int? bathroomsMax;
  final int? numberOfBedMin;
  final int? numberOfBedMax;
  final String? governorateId;
  final String? hotelName;
  final int? maximumNumberOfGuestMin;
  final int? maximumNumberOfGuestMax;
  final int? livingroomsMin;
  final int? livingroomsMax;
  final double? latitude;
  final double? longitude;
  final bool? isActive;
  final int skipCount;
  final int maxResultCount;
  final List<String>? selectedFeatures;

  const SearchFilter({
    this.filterText,
    this.propertyTypeId,
    this.checkInDate,
    this.checkOutDate,
    this.pricePerNightMin,
    this.pricePerNightMax,
    this.address,
    this.bedroomsMin,
    this.bedroomsMax,
    this.bathroomsMin,
    this.bathroomsMax,
    this.numberOfBedMin,
    this.numberOfBedMax,
    this.governorateId,
    this.hotelName,
    this.maximumNumberOfGuestMin,
    this.maximumNumberOfGuestMax,
    this.livingroomsMin,
    this.livingroomsMax,
    this.latitude,
    this.longitude,
    this.isActive = true,
    this.skipCount = 0,
    this.maxResultCount = 20,
    this.selectedFeatures,
  });

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterToJson(this);

  SearchFilter copyWith({
    String? filterText,
    String? propertyTypeId,
    int? checkInDate,
    int? checkOutDate,
    int? pricePerNightMin,
    int? pricePerNightMax,
    String? address,
    int? bedroomsMin,
    int? bedroomsMax,
    int? bathroomsMin,
    int? bathroomsMax,
    int? numberOfBedMin,
    int? numberOfBedMax,
    String? governorateId,
    String? hotelName,
    int? maximumNumberOfGuestMin,
    int? maximumNumberOfGuestMax,
    int? livingroomsMin,
    int? livingroomsMax,
    double? latitude,
    double? longitude,
    bool? isActive,
    int? skipCount,
    int? maxResultCount,
    List<String>? selectedFeatures,
  }) {
    return SearchFilter(
      filterText: filterText ?? this.filterText,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      pricePerNightMin: pricePerNightMin ?? this.pricePerNightMin,
      pricePerNightMax: pricePerNightMax ?? this.pricePerNightMax,
      address: address ?? this.address,
      bedroomsMin: bedroomsMin ?? this.bedroomsMin,
      bedroomsMax: bedroomsMax ?? this.bedroomsMax,
      bathroomsMin: bathroomsMin ?? this.bathroomsMin,
      bathroomsMax: bathroomsMax ?? this.bathroomsMax,
      numberOfBedMin: numberOfBedMin ?? this.numberOfBedMin,
      numberOfBedMax: numberOfBedMax ?? this.numberOfBedMax,
      governorateId: governorateId ?? this.governorateId,
      hotelName: hotelName ?? this.hotelName,
      maximumNumberOfGuestMin: maximumNumberOfGuestMin ?? this.maximumNumberOfGuestMin,
      maximumNumberOfGuestMax: maximumNumberOfGuestMax ?? this.maximumNumberOfGuestMax,
      livingroomsMin: livingroomsMin ?? this.livingroomsMin,
      livingroomsMax: livingroomsMax ?? this.livingroomsMax,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isActive: isActive ?? this.isActive,
      skipCount: skipCount ?? this.skipCount,
      maxResultCount: maxResultCount ?? this.maxResultCount,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
    );
  }
}

enum PropertyType {
  houses,
  hotels,
  motel,
}

extension PropertyTypeExtension on PropertyType {
  String get name {
    switch (this) {
      case PropertyType.houses:
        return 'Houses';
      case PropertyType.hotels:
        return 'Hotels';
      case PropertyType.motel:
        return 'Motel';
    }
  }

  String get icon {
    switch (this) {
      case PropertyType.houses:
        return '🏠';
      case PropertyType.hotels:
        return '🏨';
      case PropertyType.motel:
        return '🏩';
    }
  }
}

