import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/property.dart';

part 'property_model.g.dart';

@JsonSerializable()
class PropertyModel {
  @JsonKey(name: 'id')
  final String? id;

  @JsonKey(name: 'propertyTitle')
  final String propertyTitle;

  @JsonKey(name: 'hotelName')
  final String hotelName;

  @JsonKey(name: 'bedrooms')
  final int bedrooms;

  @JsonKey(name: 'bathrooms')
  final int bathrooms;

  @JsonKey(name: 'numberOfBed')
  final int numberOfBed;

  @JsonKey(name: 'floor')
  final int floor;

  @JsonKey(name: 'maximumNumberOfGuest')
  final int maximumNumberOfGuest;

  @JsonKey(name: 'livingrooms')
  final int livingrooms;

  @JsonKey(name: 'propertyDescription')
  final String propertyDescription;

  @JsonKey(name: 'hourseRules')
  final String houseRules;

  @JsonKey(name: 'importantInformation')
  final String importantInformation;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'streetAndBuildingNumber')
  final String streetAndBuildingNumber;

  @JsonKey(name: 'landMark')
  final String landMark;

  @JsonKey(name: 'pricePerNight')
  final double pricePerNight;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'propertyTypeId')
  final String propertyTypeId;

  @JsonKey(name: 'governorateId')
  final String governorateId;

  @JsonKey(name: 'propertyFeatureIds')
  final List<String> propertyFeatureIds;

  const PropertyModel({
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

  factory PropertyModel.fromJson(Map<String, dynamic> json) =>
      _$PropertyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyModelToJson(this);

  factory PropertyModel.fromEntity(Property property) {
    return PropertyModel(
      id: property.id,
      propertyTitle: property.propertyTitle,
      hotelName: property.hotelName,
      bedrooms: property.bedrooms,
      bathrooms: property.bathrooms,
      numberOfBed: property.numberOfBed,
      floor: property.floor,
      maximumNumberOfGuest: property.maximumNumberOfGuest,
      livingrooms: property.livingrooms,
      propertyDescription: property.propertyDescription,
      houseRules: property.houseRules,
      importantInformation: property.importantInformation,
      address: property.address,
      streetAndBuildingNumber: property.streetAndBuildingNumber,
      landMark: property.landMark,
      pricePerNight: property.pricePerNight,
      isActive: property.isActive,
      propertyTypeId: property.propertyTypeId,
      governorateId: property.governorateId,
      propertyFeatureIds: property.propertyFeatureIds,
    );
  }

  Property toEntity() {
    return Property(
      id: id,
      propertyTitle: propertyTitle,
      hotelName: hotelName,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      numberOfBed: numberOfBed,
      floor: floor,
      maximumNumberOfGuest: maximumNumberOfGuest,
      livingrooms: livingrooms,
      propertyDescription: propertyDescription,
      houseRules: houseRules,
      importantInformation: importantInformation,
      address: address,
      streetAndBuildingNumber: streetAndBuildingNumber,
      landMark: landMark,
      pricePerNight: pricePerNight,
      isActive: isActive,
      propertyTypeId: propertyTypeId,
      governorateId: governorateId,
      propertyFeatureIds: propertyFeatureIds,
    );
  }
}
