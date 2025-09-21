import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_creation_result.dart';
import '../repositories/property_rental_repository.dart';

class SetPropertyPriceUseCase {
  final PropertyRentalRepository repository;

  SetPropertyPriceUseCase(this.repository);

  Future<Either<Failure, PropertyCreationResult>> call({
    required String propertyId,
    required double pricePerNight,
  }) async {
    return await repository.setPropertyPrice(propertyId, pricePerNight);
  }
}
