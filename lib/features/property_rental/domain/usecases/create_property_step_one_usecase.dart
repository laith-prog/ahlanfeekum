import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property.dart';
import '../entities/property_creation_result.dart';
import '../repositories/property_rental_repository.dart';

class CreatePropertyStepOneUseCase {
  final PropertyRentalRepository repository;

  CreatePropertyStepOneUseCase(this.repository);

  Future<Either<Failure, PropertyCreationResult>> call(
    Property property,
  ) async {
    return await repository.createPropertyStepOne(property);
  }
}
