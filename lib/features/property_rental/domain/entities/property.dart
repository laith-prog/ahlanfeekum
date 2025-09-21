import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String? id;
  final String propertyTitle;
  final String hotelName;
  final int bedrooms;
  final int bathrooms;
  final int numberOfBed;
  final int floor;
  final int maximumNumberOfGuest;
  final int livingrooms;
  final String propertyDescription;
  final String houseRules;
  final String importantInformation;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;
  final double pricePerNight;
  final bool isActive;
  final String propertyTypeId;
  final String governorateId;
  final List<String> propertyFeatureIds;

  const Property({
    this.id,
    required this.propertyTitle,
    required this.hotelName,
    required this.bedrooms,
    required this.bathrooms,
    required this.numberOfBed,
    required this.floor,
    required this.maximumNumberOfGuest,
    required this.livingrooms,
    required this.propertyDescription,
    required this.houseRules,
    required this.importantInformation,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
    required this.pricePerNight,
    required this.isActive,
    required this.propertyTypeId,
    required this.governorateId,
    required this.propertyFeatureIds,
  });

  @override
  List<Object?> get props => [
    id,
    propertyTitle,
    hotelName,
    bedrooms,
    bathrooms,
    numberOfBed,
    floor,
    maximumNumberOfGuest,
    livingrooms,
    propertyDescription,
    houseRules,
    importantInformation,
    address,
    streetAndBuildingNumber,
    landMark,
    pricePerNight,
    isActive,
    propertyTypeId,
    governorateId,
    propertyFeatureIds,
  ];

  Property copyWith({
    String? id,
    String? propertyTitle,
    String? hotelName,
    int? bedrooms,
    int? bathrooms,
    int? numberOfBed,
    int? floor,
    int? maximumNumberOfGuest,
    int? livingrooms,
    String? propertyDescription,
    String? houseRules,
    String? importantInformation,
    String? address,
    String? streetAndBuildingNumber,
    String? landMark,
    double? pricePerNight,
    bool? isActive,
    String? propertyTypeId,
    String? governorateId,
    List<String>? propertyFeatureIds,
  }) {
    return Property(
      id: id ?? this.id,
      propertyTitle: propertyTitle ?? this.propertyTitle,
      hotelName: hotelName ?? this.hotelName,
      bedrooms: bedrooms ?? this.bedrooms,
      bathrooms: bathrooms ?? this.bathrooms,
      numberOfBed: numberOfBed ?? this.numberOfBed,
      floor: floor ?? this.floor,
      maximumNumberOfGuest: maximumNumberOfGuest ?? this.maximumNumberOfGuest,
      livingrooms: livingrooms ?? this.livingrooms,
      propertyDescription: propertyDescription ?? this.propertyDescription,
      houseRules: houseRules ?? this.houseRules,
      importantInformation: importantInformation ?? this.importantInformation,
      address: address ?? this.address,
      streetAndBuildingNumber:
          streetAndBuildingNumber ?? this.streetAndBuildingNumber,
      landMark: landMark ?? this.landMark,
      pricePerNight: pricePerNight ?? this.pricePerNight,
      isActive: isActive ?? this.isActive,
      propertyTypeId: propertyTypeId ?? this.propertyTypeId,
      governorateId: governorateId ?? this.governorateId,
      propertyFeatureIds: propertyFeatureIds ?? this.propertyFeatureIds,
    );
  }
}
