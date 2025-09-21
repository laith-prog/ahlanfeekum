import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_creation_result.dart';
import '../repositories/property_rental_repository.dart';

class UpdatePropertyLocationUseCase {
  final PropertyRentalRepository repository;

  UpdatePropertyLocationUseCase(this.repository);

  Future<Either<Failure, PropertyCreationResult>> call({
    required String propertyId,
    required String address,
    required String streetAndBuildingNumber,
    required String landMark,
  }) async {
    return await repository.updatePropertyLocation(
      propertyId,
      address,
      streetAndBuildingNumber,
      landMark,
    );
  }
}
