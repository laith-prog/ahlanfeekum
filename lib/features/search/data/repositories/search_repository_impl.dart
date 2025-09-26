import '../../../../core/network/api_result.dart';
import '../../domain/entities/search_entities.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';
import '../models/search_filter.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl({
    required SearchRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<ApiResult<List<LookupItemEntity>>> getPropertyTypes() async {
    try {
      print('🔍 Fetching property types...');
      final response = await _remoteDataSource.getPropertyTypes();
      print('✅ Property types response: ${response.items.length} items');
      final entities = response.items
          .map((item) => LookupItemEntity(
                id: item.id,
                displayName: item.displayName,
              ))
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      print('❌ Property types error: $error');
      return ApiResult.failure(error.toString());
    }
  }

  @override
  Future<ApiResult<List<LookupItemEntity>>> getPropertyFeatures() async {
    try {
      final response = await _remoteDataSource.getPropertyFeatures();
      final entities = response.items
          .map((item) => LookupItemEntity(
                id: item.id,
                displayName: item.displayName,
              ))
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  @override
  Future<ApiResult<List<LookupItemEntity>>> getGovernates() async {
    try {
      final response = await _remoteDataSource.getGovernates();
      final entities = response.items
          .map((item) => LookupItemEntity(
                id: item.id,
                displayName: item.displayName,
              ))
          .toList();
      return ApiResult.success(entities);
    } catch (error) {
      return ApiResult.failure(error.toString());
    }
  }

  @override
  Future<ApiResult<SearchResultEntity>> searchProperties(SearchFilter filter) async {
    try {
      final queryMap = SearchRemoteDataSourceHelper.filterToQueryMap(filter);
      print('🔍 ===== SEARCH PROPERTIES =====');
      print('🔍 Original filter: ${filter.toJson()}');
      print('🔍 Query map for API: $queryMap');
      print('🔍 GovernorateId in query: ${queryMap['GovernorateId']}');
      
      final response = await _remoteDataSource.searchProperties(queryMap);
      print('✅ Search API response: ${response.items.length} properties found');
      print('✅ Total count from API: ${response.totalCount}');
      
      final entities = response.items
          .map((property) => PropertyEntity(
                id: property.id,
                title: property.title,
                description: property.description,
                pricePerNight: property.pricePerNight,
                address: property.address,
                cityName: property.cityName,
                governateName: property.governateName,
                bedrooms: property.bedrooms,
                bathrooms: property.bathrooms,
                livingrooms: property.livingrooms,
                rating: property.rating,
                mainImage: property.mainImage,
                features: property.features,
                propertyTypeId: property.propertyTypeId,
                propertyTypeName: property.propertyTypeName,
                hotelName: property.hotelName,
                isActive: property.isActive,
              ))
          .toList();

      final searchResult = SearchResultEntity(
        properties: entities,
        totalCount: response.totalCount,
      );

      return ApiResult.success(searchResult);
    } catch (error) {
      print('❌ Search properties error: $error');
      return ApiResult.failure(error.toString());
    }
  }
}
