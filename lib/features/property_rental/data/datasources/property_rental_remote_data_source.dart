import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/property_model.dart';
import '../models/property_availability_model.dart';
import '../models/property_image_model.dart';
import '../models/property_creation_result_model.dart';

abstract class PropertyRentalRemoteDataSource {
  Future<PropertyCreationResultModel> createPropertyStepOne(
    PropertyModel property,
  );
  Future<PropertyCreationResultModel> updatePropertyLocation({
    required String propertyId,
    required String address,
    required String streetAndBuildingNumber,
    required String landMark,
  });
  Future<PropertyCreationResultModel> addPropertyAvailability({
    required String propertyId,
    required List<PropertyAvailabilityModel> availabilities,
  });
  Future<PropertyCreationResultModel> uploadPropertyImages({
    required String propertyId,
    required List<PropertyImageModel> images,
  });
  Future<PropertyCreationResultModel> setPropertyPrice({
    required String propertyId,
    required double pricePerNight,
  });
  Future<String> uploadSingleImage(String imagePath);
}

@Injectable(as: PropertyRentalRemoteDataSource)
class PropertyRentalRemoteDataSourceImpl
    implements PropertyRentalRemoteDataSource {
  final Dio _dio;
  static const String baseUrl = 'http://srv954186.hstgr.cloud:5000/api/mobile';

  PropertyRentalRemoteDataSourceImpl(this._dio);

  @override
  Future<PropertyCreationResultModel> createPropertyStepOne(
    PropertyModel property,
  ) async {
    try {
      final response = await _dio.post(
        '$baseUrl/properties/create-step-one',
        data: property.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PropertyCreationResultModel.fromJson({
          'success': true,
          'data': response.data,
        });
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to create property: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<PropertyCreationResultModel> updatePropertyLocation({
    required String propertyId,
    required String address,
    required String streetAndBuildingNumber,
    required String landMark,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/properties/create-step-two',
        data: {
          'id': propertyId,
          'address': address,
          'streetAndBuildingNumber': streetAndBuildingNumber,
          'landMark': landMark,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PropertyCreationResultModel.fromJson({
          'success': true,
          'data': response.data,
        });
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to update location: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<PropertyCreationResultModel> addPropertyAvailability({
    required String propertyId,
    required List<PropertyAvailabilityModel> availabilities,
  }) async {
    try {
      final availabilityData = availabilities.map((availability) {
        return availability.toJson();
      }).toList();

      final response = await _dio.post(
        '$baseUrl/properties/add-availability',
        data: availabilityData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PropertyCreationResultModel.fromJson({
          'success': true,
          'data': response.data,
        });
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to add availability: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<PropertyCreationResultModel> uploadPropertyImages({
    required String propertyId,
    required List<PropertyImageModel> images,
  }) async {
    try {
      final uploadData = images.map((image) => image.toJson()).toList();

      final response = await _dio.post(
        '$baseUrl/properties/upload-images',
        data: uploadData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PropertyCreationResultModel.fromJson({
          'success': true,
          'data': response.data,
        });
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to upload images: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<PropertyCreationResultModel> setPropertyPrice({
    required String propertyId,
    required double pricePerNight,
  }) async {
    try {
      final response = await _dio.post(
        '$baseUrl/properties/set-price',
        data: {'propertyId': propertyId, 'pricePerNight': pricePerNight},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PropertyCreationResultModel.fromJson({
          'success': true,
          'data': response.data,
        });
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to set price: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }

  @override
  Future<String> uploadSingleImage(String imagePath) async {
    try {
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        '$baseUrl/properties/upload-single-image',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['imageUrl'] ?? 'uploaded_image_url.jpg';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          message: 'Failed to upload image: ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        message: e.message ?? 'Network error occurred',
      );
    }
  }
}
