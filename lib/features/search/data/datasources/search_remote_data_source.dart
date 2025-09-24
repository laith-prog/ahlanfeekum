import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/lookup_item.dart';
import '../models/property.dart';
import '../models/search_filter.dart';

abstract class SearchRemoteDataSource {
  Future<LookupResponse> getPropertyTypes();
  Future<LookupResponse> getPropertyFeatures();
  Future<LookupResponse> getGovernates();
  Future<PropertySearchResponse> searchProperties(Map<String, dynamic> queries);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImpl(this._dio);

  @override
  Future<LookupResponse> getPropertyTypes() async {
    try {
      final response = await _dio.get(AppConstants.propertyTypesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      print('🚨 Error fetching property types: $e');
      rethrow;
    }
  }

  @override
  Future<LookupResponse> getPropertyFeatures() async {
    try {
      final response = await _dio.get(AppConstants.propertyFeaturesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      print('🚨 Error fetching property features: $e');
      rethrow;
    }
  }

  @override
  Future<LookupResponse> getGovernates() async {
    try {
      final response = await _dio.get(AppConstants.governatesEndpoint);
      return LookupResponse.fromJson(response.data);
    } catch (e) {
      print('🚨 Error fetching governates: $e');
      rethrow;
    }
  }

  @override
  Future<PropertySearchResponse> searchProperties(
    Map<String, dynamic> queries,
  ) async {
    try {
      print('🔍 Search Properties Request:');
      print(
        '🔍 URI: ${AppConstants.baseUrl}${AppConstants.searchPropertyEndpoint}',
      );
      print('🔍 Method: GET');
      print('🔍 Query Parameters: $queries');

      final response = await _dio.get(
        AppConstants.searchPropertyEndpoint,
        queryParameters: queries,
      );

      print('✅ Search Properties Response: ${response.statusCode}');
      print('✅ Found ${response.data['totalCount'] ?? 0} properties');

      return PropertySearchResponse.fromJson(response.data);
    } catch (e) {
      print('🚨 Error searching properties: $e');
      rethrow;
    }
  }
}

abstract class SearchRemoteDataSourceHelper {
  static Map<String, dynamic> filterToQueryMap(SearchFilter filter) {
    final Map<String, dynamic> queryMap = {};

    if (filter.filterText != null && filter.filterText!.isNotEmpty) {
      queryMap['FilterText'] = filter.filterText;
    }

    if (filter.propertyTypeId != null) {
      queryMap['PropertyTypeId'] = filter.propertyTypeId;
    }

    if (filter.checkInDate != null) {
      queryMap['CheckInDate'] = filter.checkInDate;
    }

    if (filter.checkOutDate != null) {
      queryMap['CheckOutDate'] = filter.checkOutDate;
    }

    if (filter.pricePerNightMin != null) {
      queryMap['PricePerNightMin'] = filter.pricePerNightMin;
    }

    if (filter.pricePerNightMax != null) {
      queryMap['PricePerNightMax'] = filter.pricePerNightMax;
    }

    if (filter.address != null && filter.address!.isNotEmpty) {
      queryMap['Address'] = filter.address;
    }

    if (filter.bathroomsMin != null) {
      queryMap['BathroomsMin'] = filter.bathroomsMin;
    }

    if (filter.bathroomsMax != null) {
      queryMap['BathroomsMax'] = filter.bathroomsMax;
    }

    if (filter.hotelName != null && filter.hotelName!.isNotEmpty) {
      queryMap['HotelName'] = filter.hotelName;
    }

    if (filter.livingroomsMin != null) {
      queryMap['LivingroomsMin'] = filter.livingroomsMin;
    }

    if (filter.livingroomsMax != null) {
      queryMap['LivingroomsMax'] = filter.livingroomsMax;
    }

    if (filter.isActive != null) {
      queryMap['IsActive'] = filter.isActive;
    }

    queryMap['SkipCount'] = filter.skipCount;
    queryMap['MaxResultCount'] = filter.maxResultCount;

    return queryMap;
  }
}
