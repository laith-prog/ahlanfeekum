import 'package:equatable/equatable.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_creation_result.dart';

abstract class PropertyRentalState extends Equatable {
  const PropertyRentalState();

  @override
  List<Object?> get props => [];
}

class PropertyRentalInitial extends PropertyRentalState {
  const PropertyRentalInitial();
}

class PropertyRentalLoading extends PropertyRentalState {
  final String? message;

  const PropertyRentalLoading({this.message});

  @override
  List<Object?> get props => [message];
}

class PropertyStepOneCompleted extends PropertyRentalState {
  final PropertyCreationResult result;
  final Property property;

  const PropertyStepOneCompleted({
    required this.result,
    required this.property,
  });

  @override
  List<Object?> get props => [result, property];
}

class PropertyLocationUpdated extends PropertyRentalState {
  final PropertyCreationResult result;

  const PropertyLocationUpdated({required this.result});

  @override
  List<Object?> get props => [result];
}

class PropertyAvailabilityAdded extends PropertyRentalState {
  final PropertyCreationResult result;

  const PropertyAvailabilityAdded({required this.result});

  @override
  List<Object?> get props => [result];
}

class PropertyImagesUploaded extends PropertyRentalState {
  final PropertyCreationResult result;

  const PropertyImagesUploaded({required this.result});

  @override
  List<Object?> get props => [result];
}

class PropertyPriceSet extends PropertyRentalState {
  final PropertyCreationResult result;

  const PropertyPriceSet({required this.result});

  @override
  List<Object?> get props => [result];
}

class PropertyCreationCompleted extends PropertyRentalState {
  final String propertyId;
  final String message;

  const PropertyCreationCompleted({
    required this.propertyId,
    required this.message,
  });

  @override
  List<Object?> get props => [propertyId, message];
}

class PropertyRentalError extends PropertyRentalState {
  final String message;

  const PropertyRentalError({required this.message});

  @override
  List<Object?> get props => [message];
}
