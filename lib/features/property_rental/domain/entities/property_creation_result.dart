import 'package:equatable/equatable.dart';

class PropertyCreationResult extends Equatable {
  final bool success;
  final String? propertyId;
  final String? message;

  const PropertyCreationResult({
    required this.success,
    this.propertyId,
    this.message,
  });

  @override
  List<Object?> get props => [success, propertyId, message];
}
