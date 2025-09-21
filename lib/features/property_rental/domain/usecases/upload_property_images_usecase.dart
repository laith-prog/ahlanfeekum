import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property_image.dart';
import '../entities/property_creation_result.dart';
import '../repositories/property_rental_repository.dart';

class UploadPropertyImagesUseCase {
  final PropertyRentalRepository repository;

  UploadPropertyImagesUseCase(this.repository);

  Future<Either<Failure, PropertyCreationResult>> call({
    required String propertyId,
    required List<PropertyImage> images,
  }) async {
    return await repository.uploadPropertyImages(propertyId, images);
  }
}
