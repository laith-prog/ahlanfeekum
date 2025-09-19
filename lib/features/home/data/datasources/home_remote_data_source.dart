import 'package:dio/dio.dart';
import '../models/home_response.dart';

abstract class HomeRemoteDataSource {
  Future<HomeResponse> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _dio.get('user-profiles/home');
      return HomeResponse.fromJson(response.data);
    } catch (e) {
      print('🚨 Error fetching home data: $e');
      rethrow;
    }
  }
}
