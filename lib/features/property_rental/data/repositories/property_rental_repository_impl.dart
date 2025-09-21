import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_availability.dart';
import '../../domain/entities/property_image.dart';
import '../../domain/entities/property_creation_result.dart';
import '../../domain/repositories/property_rental_repository.dart';
import '../datasources/property_rental_remote_data_source.dart';
import '../models/property_model.dart';
import '../models/property_availability_model.dart';
import '../models/property_image_model.dart';

@Injectable(as: PropertyRentalRepository)
class PropertyRentalRepositoryImpl implements PropertyRentalRepository {
  final PropertyRentalRemoteDataSource remoteDataSource;

  PropertyRentalRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, PropertyCreationResult>> createPropertyStepOne(
    Property property,
  ) async {
    try {
      final propertyModel = PropertyModel.fromEntity(property);
      final result = await remoteDataSource.createPropertyStepOne(
        propertyModel,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, PropertyCreationResult>> updatePropertyLocation(
    String propertyId,
    String address,
    String streetAndBuildingNumber,
    String landMark,
  ) async {
    try {
      final result = await remoteDataSource.updatePropertyLocation(
        propertyId: propertyId,
        address: address,
        streetAndBuildingNumber: streetAndBuildingNumber,
        landMark: landMark,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, PropertyCreationResult>> addPropertyAvailability(
    String propertyId,
    List<PropertyAvailability> availabilities,
  ) async {
    try {
      final availabilityModels = availabilities
          .map(
            (availability) =>
                PropertyAvailabilityModel.fromEntity(availability),
          )
          .toList();

      final result = await remoteDataSource.addPropertyAvailability(
        propertyId: propertyId,
        availabilities: availabilityModels,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, PropertyCreationResult>> uploadPropertyImages(
    String propertyId,
    List<PropertyImage> images,
  ) async {
    try {
      // First, upload individual images to get their URLs
      List<PropertyImage> uploadedImages = [];

      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        try {
          final uploadedUrl = await remoteDataSource.uploadSingleImage(
            image.imagePath,
          );
          uploadedImages.add(image.copyWith(imagePath: uploadedUrl));
        } catch (e) {
          // If individual image upload fails, use placeholder
          uploadedImages.add(
            image.copyWith(imagePath: 'placeholder_${i + 1}.jpg'),
          );
        }
      }

      final imageModels = uploadedImages
          .map((image) => PropertyImageModel.fromEntity(image))
          .toList();

      final result = await remoteDataSource.uploadPropertyImages(
        propertyId: propertyId,
        images: imageModels,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, PropertyCreationResult>> setPropertyPrice(
    String propertyId,
    double pricePerNight,
  ) async {
    try {
      final result = await remoteDataSource.setPropertyPrice(
        propertyId: propertyId,
        pricePerNight: pricePerNight,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadSingleImage(String imagePath) async {
    try {
      final result = await remoteDataSource.uploadSingleImage(imagePath);
      return Right(result);
    } on DioException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred: $e'));
    }
  }

  Failure _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerFailure(
          'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            return ServerFailure('Client error: ${e.message ?? 'Bad request'}');
          } else if (statusCode >= 500) {
            return ServerFailure(
              'Server error: ${e.message ?? 'Internal server error'}',
            );
          }
        }
        return ServerFailure('Bad response: ${e.message ?? 'Unknown error'}');
      case DioExceptionType.cancel:
        return ServerFailure('Request was cancelled');
      case DioExceptionType.connectionError:
        return ServerFailure(
          'No internet connection. Please check your connection.',
        );
      case DioExceptionType.badCertificate:
        return ServerFailure('Certificate error occurred');
      case DioExceptionType.unknown:
      default:
        return ServerFailure(
          'Network error: ${e.message ?? 'Unknown error occurred'}',
        );
    }
  }
}
