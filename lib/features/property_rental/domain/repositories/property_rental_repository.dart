import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/property.dart';
import '../entities/property_availability.dart';
import '../entities/property_image.dart';
import '../entities/property_creation_result.dart';

abstract class PropertyRentalRepository {
  Future<Either<Failure, PropertyCreationResult>> createPropertyStepOne(
    Property property,
  );

  Future<Either<Failure, PropertyCreationResult>> updatePropertyLocation(
    String propertyId,
    String address,
    String streetAndBuildingNumber,
    String landMark,
  );

  Future<Either<Failure, PropertyCreationResult>> addPropertyAvailability(
    String propertyId,
    List<PropertyAvailability> availabilities,
  );

  Future<Either<Failure, PropertyCreationResult>> uploadPropertyImages(
    String propertyId,
    List<PropertyImage> images,
  );

  Future<Either<Failure, PropertyCreationResult>> setPropertyPrice(
    String propertyId,
    double pricePerNight,
  );

  Future<Either<Failure, String>> uploadSingleImage(String imagePath);
}
