import 'dart:io';

class PropertyFormData {
  // Step 1: Property Details
  String? propertyTitle;
  String? propertyTypeId;
  String? propertyTypeName;
  int bedrooms;
  int bathrooms;
  int numberOfBeds;
  int floor;
  int maximumNumberOfGuests;
  int livingRooms;
  String? propertyDescription;
  String? houseRules;
  String? importantInformation;
  List<String> propertyFeatureIds;
  List<String> selectedFeatures;

  // Step 2: Photos
  List<File> selectedImages;
  int? primaryImageIndex;

  // Step 3: Price
  int? pricePerNight;

  // Step 4: Location
  String? address;
  String? streetAndBuildingNumber;
  String? landMark;
  String? governorateId;
  String? governorateName;
  double? latitude;
  double? longitude;

  // Step 5: Availability
  List<DateTime> availableDates;
  Map<DateTime, bool> dateAvailability;

  // Property ID (after step 1 creation)
  String? propertyId;

  PropertyFormData({
    this.propertyTitle,
    this.propertyTypeId,
    this.propertyTypeName,
    this.bedrooms = 1,
    this.bathrooms = 1,
    this.numberOfBeds = 1,
    this.floor = 1,
    this.maximumNumberOfGuests = 1,
    this.livingRooms = 1,
    this.propertyDescription,
    this.houseRules,
    this.importantInformation,
    this.propertyFeatureIds = const [],
    this.selectedFeatures = const [],
    this.selectedImages = const [],
    this.primaryImageIndex,
    this.pricePerNight,
    this.address,
    this.streetAndBuildingNumber,
    this.landMark,
    this.governorateId,
    this.governorateName,
    this.latitude,
    this.longitude,
    this.availableDates = const [],
    this.dateAvailability = const {},
    this.propertyId,
  });

  PropertyFormData copyWith({
    String? propertyTitle,
    String? propertyTypeId,
    String? propertyTypeName,
    int? bedrooms,
    int? bathrooms,
    int? numberOfBeds,
    int? floor,
    int? maximumNumberOfGuests,
    int? livingRooms,
    String? propertyDescription,
    String? houseRules,
    String? importantInformation,
    List<String>? propertyFeatureIds,
    List<String>? selectedFeatures,
    List<File>? selectedImages,
    int? primaryImageIndex,
    int? pricePerNight,
    String? address,
    String? streetAndBuildingNumber,
    String? landMark,
    String? governorateId,
    String? governorateName,
    double? latitude,
    double? longitude,
    List<DateTime>? availableDates,
    Map<DateTime, bool>? dateAvailability,
    String? propertyId,
  }) {
    return PropertyFormData(
      propertyTitle: propertyTitle ?? this.propertyTitle,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      propertyTypeName: propertyTypeName ?? this.propertyTypeName,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      numberOfBeds: numberOfBeds ?? this.numberOfBeds,
      floor: floor ?? this.floor,
      maximumNumberOfGuests: maximumNumberOfGuests ?? this.maximumNumberOfGuests,
      livingRooms: livingRooms ?? this.livingRooms,
      propertyDescription: propertyDescription ?? this.propertyDescription,
      houseRules: houseRules ?? this.houseRules,
      importantInformation: importantInformation ?? this.importantInformation,
      propertyFeatureIds: propertyFeatureIds ?? this.propertyFeatureIds,
      selectedFeatures: selectedFeatures ?? this.selectedFeatures,
      selectedImages: selectedImages ?? this.selectedImages,
      primaryImageIndex: primaryImageIndex ?? this.primaryImageIndex,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      address: address ?? this.address,
      streetAndBuildingNumber: streetAndBuildingNumber ?? this.streetAndBuildingNumber,
      landMark: landMark ?? this.landMark,
      governorateId: governorateId ?? this.governorateId,
      governorateName: governorateName ?? this.governorateName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      availableDates: availableDates ?? this.availableDates,
      dateAvailability: dateAvailability ?? this.dateAvailability,
      propertyId: propertyId ?? this.propertyId,
    );
  }

  bool get isStep1Valid {
    return propertyTitle != null &&
        propertyTitle!.isNotEmpty &&
        propertyTypeId != null &&
        propertyTypeId!.isNotEmpty &&
        governorateId != null &&
        governorateId!.isNotEmpty;
  }

  bool get isLocationStepValid {
    return address != null &&
        address!.isNotEmpty &&
        streetAndBuildingNumber != null &&
        streetAndBuildingNumber!.isNotEmpty &&
        landMark != null &&
        landMark!.isNotEmpty;
  }

  bool get isBothDetailsAndLocationValid {
    return isStep1Valid && isLocationStepValid;
  }

  bool get isStep2Valid {
    return selectedImages.isNotEmpty;
  }

  bool get isStep3Valid {
    return pricePerNight != null && pricePerNight! > 0;
  }

  bool get isStep4Valid {
    return address != null &&
        address!.isNotEmpty &&
        streetAndBuildingNumber != null &&
        streetAndBuildingNumber!.isNotEmpty &&
        landMark != null &&
        landMark!.isNotEmpty;
  }

  bool get isStep5Valid {
    return availableDates.isNotEmpty;
  }
}
