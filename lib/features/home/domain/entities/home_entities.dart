class HomeData {
  final List<SpecialAdvertisement> specialAdvertisements;
  final List<Property> siteProperties;
  final List<Property> highlyRatedProperties;
  final List<Governorate> governorates;
  final OnlyForYouSection onlyForYouSection;

  const HomeData({
    required this.specialAdvertisements,
    required this.siteProperties,
    required this.highlyRatedProperties,
    required this.governorates,
    required this.onlyForYouSection,
  });
}

class SpecialAdvertisement {
  final String id;
  final String imageUrl;
  final String propertyId;
  final String propertyTitle;

  const SpecialAdvertisement({
    required this.id,
    required this.imageUrl,
    required this.propertyId,
    required this.propertyTitle,
  });
}

class Property {
  final String id;
  final String title;
  final String? hotelName;
  final String? address;
  final String? streetAndBuildingNumber;
  final String? landmark;
  final double pricePerNight;
  final bool isActive;
  final bool isFavorite;
  final String? mainImageUrl;

  const Property({
    required this.id,
    required this.title,
    this.hotelName,
    this.address,
    this.streetAndBuildingNumber,
    this.landmark,
    required this.pricePerNight,
    required this.isActive,
    required this.isFavorite,
    this.mainImageUrl,
  });

  String get displayLocation {
    if (address != null && address!.isNotEmpty) return address!;
    if (streetAndBuildingNumber != null && streetAndBuildingNumber!.isNotEmpty) {
      return streetAndBuildingNumber!;
    }
    if (landmark != null && landmark!.isNotEmpty) return landmark!;
    return 'Location not specified';
  }
}

class Governorate {
  final String id;
  final String title;

  const Governorate({
    required this.id,
    required this.title,
  });
}

class OnlyForYouSection {
  final String id;
  final String firstPhotoUrl;
  final String secondPhotoUrl;
  final String thirdPhotoUrl;

  const OnlyForYouSection({
    required this.id,
    required this.firstPhotoUrl,
    required this.secondPhotoUrl,
    required this.thirdPhotoUrl,
  });
}
