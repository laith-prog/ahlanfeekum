import '../../../../core/network/api_result.dart';
import '../entities/home_entities.dart';

abstract class HomeRepository {
  Future<ApiResult<HomeData>> getHomeData();
}
