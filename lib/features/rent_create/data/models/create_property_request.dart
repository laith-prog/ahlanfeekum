import 'package:json_annotation/json_annotation.dart';

part 'create_property_request.g.dart';

@JsonSerializable()
class CreatePropertyStepOneRequest {
  final String propertyTitle;
  final String? hotelName;
  final int bedrooms;
  final int bathrooms;
  final int numberOfBed;
  final int floor;
  final int maximumNumberOfGuest;
  final int livingrooms;
  final String propertyDescription;
  final String hourseRules;
  final String importantInformation;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;
  final int pricePerNight;
  final bool isActive;
  final String propertyTypeId;
  final String governorateId;
  final List<String> propertyFeatureIds;

  const CreatePropertyStepOneRequest({
    required this.propertyTitle,
    this.hotelName,
    required this.bedrooms,
    required this.bathrooms,
    required this.numberOfBed,
    required this.floor,
    required this.maximumNumberOfGuest,
    required this.livingrooms,
    required this.propertyDescription,
    required this.hourseRules,
    required this.importantInformation,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
    required this.pricePerNight,
    this.isActive = true,
    required this.propertyTypeId,
    required this.governorateId,
    required this.propertyFeatureIds,
  });

  factory CreatePropertyStepOneRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePropertyStepOneRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePropertyStepOneRequestToJson(this);
}

@JsonSerializable()
class CreatePropertyStepTwoRequest {
  final String id;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;

  const CreatePropertyStepTwoRequest({
    required this.id,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
  });

  factory CreatePropertyStepTwoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePropertyStepTwoRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePropertyStepTwoRequestToJson(this);
}

@JsonSerializable()
class PropertyAvailability {
  final String propertyId;
  final String date;
  final bool isAvailable;
  final int price;
  final String note;

  const PropertyAvailability({
    required this.propertyId,
    required this.date,
    required this.isAvailable,
    required this.price,
    required this.note,
  });

  factory PropertyAvailability.fromJson(Map<String, dynamic> json) =>
      _$PropertyAvailabilityFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyAvailabilityToJson(this);
}

@JsonSerializable()
class PropertyMediaUpload {
  final String propertyId;
  final String image;
  final int order;
  final bool isActive;

  const PropertyMediaUpload({
    required this.propertyId,
    required this.image,
    required this.order,
    this.isActive = true,
  });

  factory PropertyMediaUpload.fromJson(Map<String, dynamic> json) =>
      _$PropertyMediaUploadFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyMediaUploadToJson(this);
}

@JsonSerializable()
class SetPriceRequest {
  final String propertyId;
  final int pricePerNight;

  const SetPriceRequest({
    required this.propertyId,
    required this.pricePerNight,
  });

  factory SetPriceRequest.fromJson(Map<String, dynamic> json) =>
      _$SetPriceRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SetPriceRequestToJson(this);
}
