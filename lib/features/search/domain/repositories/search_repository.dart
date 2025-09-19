import '../../../../core/network/api_result.dart';
import '../entities/search_entities.dart';
import '../../data/models/search_filter.dart';

abstract class SearchRepository {
  Future<ApiResult<List<LookupItemEntity>>> getPropertyTypes();
  Future<ApiResult<List<LookupItemEntity>>> getPropertyFeatures();
  Future<ApiResult<List<LookupItemEntity>>> getGovernates();
  Future<ApiResult<SearchResultEntity>> searchProperties(SearchFilter filter);
}

