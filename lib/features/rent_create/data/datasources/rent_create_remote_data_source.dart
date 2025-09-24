import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/create_property_request.dart';
import '../models/create_property_response.dart';

abstract class RentCreateRemoteDataSource {
  Future<CreatePropertyResponse> createPropertyStepOne(CreatePropertyStepOneRequest request);
  Future<CreatePropertyResponse> createPropertyStepTwo(CreatePropertyStepTwoRequest request);
  Future<ApiResponse<bool>> addAvailability(List<PropertyAvailability> availability);
  Future<String> uploadSingleMedia(String propertyId, File image, int order);
  Future<ApiResponse<List<String>>> uploadMultipleMedia(List<PropertyMediaUpload> media);
  Future<ApiResponse<bool>> setPrice(SetPriceRequest request);
}

class RentCreateRemoteDataSourceImpl implements RentCreateRemoteDataSource {
  final Dio _dio;

  RentCreateRemoteDataSourceImpl(this._dio);

  @override
  Future<CreatePropertyResponse> createPropertyStepOne(CreatePropertyStepOneRequest request) async {
    try {
      final requestData = request.toJson();
      print('🔍 Serialized JSON Map: $requestData');
      
      // Convert to JSON string to ensure proper formatting
      final jsonString = jsonEncode(requestData);
      print('🔍 JSON String: $jsonString');
      
      final response = await _dio.post(
        AppConstants.createPropertyStepOne,
        data: jsonString,
      );

      return CreatePropertyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create property step one: $e');
    }
  }

  @override
  Future<CreatePropertyResponse> createPropertyStepTwo(CreatePropertyStepTwoRequest request) async {
    try {
      final response = await _dio.post(
        AppConstants.createPropertyStepTwo,
        data: request.toJson(),
      );

      return CreatePropertyResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create property step two: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> addAvailability(List<PropertyAvailability> availability) async {
    try {
      final response = await _dio.post(
        AppConstants.addAvailability,
        data: availability.map((e) => e.toJson()).toList(),
      );

      return ApiResponse.fromJson(response.data, (json) => json as bool);
    } catch (e) {
      throw Exception('Failed to add availability: $e');
    }
  }

  @override
  Future<String> uploadSingleMedia(String propertyId, File image, int order) async {
    try {
      final formData = FormData.fromMap({
        'PropertyId': propertyId,
        'Image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'Order': order,
        'isActive': true,
      });

      final response = await _dio.post(
        AppConstants.uploadSingleMedia,
        data: formData,
      );

      return response.data['data'] ?? '';
    } catch (e) {
      throw Exception('Failed to upload single media: $e');
    }
  }

  @override
  Future<ApiResponse<List<String>>> uploadMultipleMedia(List<PropertyMediaUpload> media) async {
    try {
      final response = await _dio.post(
        AppConstants.uploadMultipleMedia,
        data: media.map((e) => e.toJson()).toList(),
      );

      return ApiResponse.fromJson(
        response.data,
        (json) => (json as List).cast<String>(),
      );
    } catch (e) {
      throw Exception('Failed to upload multiple media: $e');
    }
  }

  @override
  Future<ApiResponse<bool>> setPrice(SetPriceRequest request) async {
    try {
      final response = await _dio.post(
        AppConstants.setPrice,
        data: request.toJson(),
      );

      return ApiResponse.fromJson(response.data, (json) => json as bool);
    } catch (e) {
      throw Exception('Failed to set price: $e');
    }
  }
}
