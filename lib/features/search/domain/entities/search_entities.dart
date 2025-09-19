class PropertyEntity {
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

  const PropertyEntity({
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
  });
}

class LookupItemEntity {
  final String id;
  final String displayName;

  const LookupItemEntity({
    required this.id,
    required this.displayName,
  });
}

class SearchResultEntity {
  final List<PropertyEntity> properties;
  final int totalCount;

  const SearchResultEntity({
    required this.properties,
    required this.totalCount,
  });
}

