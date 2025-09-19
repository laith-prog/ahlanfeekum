import 'package:json_annotation/json_annotation.dart';

part 'search_filter.g.dart';

@JsonSerializable()
class SearchFilter {
  final String? filterText;
  final String? propertyTypeId;
  final int? checkInDate;
  final int? checkOutDate;
  final double? pricePerNightMin;
  final double? pricePerNightMax;
  final String? address;
  final int? bathroomsMin;
  final int? bathroomsMax;
  final String? hotelName;
  final int? livingroomsMin;
  final int? livingroomsMax;
  final bool? isActive;
  final int skipCount;
  final int maxResultCount;
  final List<String>? selectedFeatures;
  final String? governateId;

  const SearchFilter({
    this.filterText,
    this.propertyTypeId,
    this.checkInDate,
    this.checkOutDate,
    this.pricePerNightMin,
    this.pricePerNightMax,
    this.address,
    this.bathroomsMin,
    this.bathroomsMax,
    this.hotelName,
    this.livingroomsMin,
    this.livingroomsMax,
    this.isActive = true,
    this.skipCount = 0,
    this.maxResultCount = 20,
    this.selectedFeatures,
    this.governateId,
  });

  factory SearchFilter.fromJson(Map<String, dynamic> json) =>
      _$SearchFilterFromJson(json);

  Map<String, dynamic> toJson() => _$SearchFilterToJson(this);

  SearchFilter copyWith({
    String? filterText,
    String? propertyTypeId,
    int? checkInDate,
    int? checkOutDate,
    double? pricePerNightMin,
    double? pricePerNightMax,
    String? address,
    int? bathroomsMin,
    int? bathroomsMax,
    String? hotelName,
    int? livingroomsMin,
    int? livingroomsMax,
    bool? isActive,
    int? skipCount,
    int? maxResultCount,
    List<String>? selectedFeatures,
    String? governateId,
  }) {
    return SearchFilter(
      filterText: filterText ?? this.filterText,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      pricePerNightMin: pricePerNightMin ?? this.pricePerNightMin,
      pricePerNightMax: pricePerNightMax ?? this.pricePerNightMax,
      address: address ?? this.address,
      bathroomsMin: bathroomsMin ?? this.bathroomsMin,
      bathroomsMax: bathroomsMax ?? this.bathroomsMax,
      hotelName: hotelName ?? this.hotelName,
      livingroomsMin: livingroomsMin ?? this.livingroomsMin,
      livingroomsMax: livingroomsMax ?? this.livingroomsMax,
      isActive: isActive ?? this.isActive,
      skipCount: skipCount ?? this.skipCount,
      maxResultCount: maxResultCount ?? this.maxResultCount,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      governateId: governateId ?? this.governateId,
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

