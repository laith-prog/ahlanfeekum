import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_availability.dart';
import '../entities/property_creation_result.dart';
import '../repositories/property_rental_repository.dart';

class AddPropertyAvailabilityUseCase {
  final PropertyRentalRepository repository;

  AddPropertyAvailabilityUseCase(this.repository);

  Future<Either<Failure, PropertyCreationResult>> call({
    required String propertyId,
    required List<PropertyAvailability> availabilities,
  }) async {
    return await repository.addPropertyAvailability(propertyId, availabilities);
  }
}
