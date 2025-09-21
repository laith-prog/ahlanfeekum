import 'package:equatable/equatable.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_availability.dart';
import '../../domain/entities/property_image.dart';

abstract class PropertyRentalEvent extends Equatable {
  const PropertyRentalEvent();

  @override
  List<Object?> get props => [];
}

class CreatePropertyStepOneEvent extends PropertyRentalEvent {
  final Property property;

  const CreatePropertyStepOneEvent({required this.property});

  @override
  List<Object?> get props => [property];
}

class UpdatePropertyLocationEvent extends PropertyRentalEvent {
  final String propertyId;
  final String address;
  final String streetAndBuildingNumber;
  final String landMark;

  const UpdatePropertyLocationEvent({
    required this.propertyId,
    required this.address,
    required this.streetAndBuildingNumber,
    required this.landMark,
  });

  @override
  List<Object?> get props => [
    propertyId,
    address,
    streetAndBuildingNumber,
    landMark,
  ];
}

class AddPropertyAvailabilityEvent extends PropertyRentalEvent {
  final String propertyId;
  final List<PropertyAvailability> availabilities;

  const AddPropertyAvailabilityEvent({
    required this.propertyId,
    required this.availabilities,
  });

  @override
  List<Object?> get props => [propertyId, availabilities];
}

class UploadPropertyImagesEvent extends PropertyRentalEvent {
  final String propertyId;
  final List<PropertyImage> images;

  const UploadPropertyImagesEvent({
    required this.propertyId,
    required this.images,
  });

  @override
  List<Object?> get props => [propertyId, images];
}

class SetPropertyPriceEvent extends PropertyRentalEvent {
  final String propertyId;
  final double pricePerNight;

  const SetPropertyPriceEvent({
    required this.propertyId,
    required this.pricePerNight,
  });

  @override
  List<Object?> get props => [propertyId, pricePerNight];
}

class CompletePropertyCreationEvent extends PropertyRentalEvent {
  final Property property;
  final List<PropertyAvailability> availabilities;
  final List<PropertyImage> images;

  const CompletePropertyCreationEvent({
    required this.property,
    required this.availabilities,
    required this.images,
  });

  @override
  List<Object?> get props => [property, availabilities, images];
}

class ResetPropertyRentalEvent extends PropertyRentalEvent {
  const ResetPropertyRentalEvent();
}
