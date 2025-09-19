import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../di/injection.dart';

class DioFactory {
  static Dio? _dio;

  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = AppConstants.baseUrl;
      _dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;

      if (kDebugMode) {
        _dio!.interceptors.add(
          LogInterceptor(
            requestBody: true,
            responseBody: true,
            requestHeader: true,
            responseHeader: true,
          ),
        );
      }

      _dio!.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            options.headers['Content-Type'] = 'application/json';
            options.headers['X-Requested-With'] = 'XMLHttpRequest';
            options.headers['accept'] = 'text/plain';
            
            // Add Authorization header
            try {
              final sharedPreferences = getIt<SharedPreferences>();
              final token = sharedPreferences.getString(AppConstants.accessTokenKey);
              
              if (token != null && token.isNotEmpty) {
                options.headers['Authorization'] = 'Bearer $token';
                print('🔑 Added auth token to request: ${options.path}');
              } else {
                print('⚠️ No auth token found for request: ${options.path}');
              }
            } catch (e) {
              print('🚨 Error adding auth header: $e');
            }
            
            handler.next(options);
          },
          onError: (error, handler) {
            print('🚨 Dio error: ${error.message}');
            if (error.response != null) {
              print('🚨 Response status: ${error.response?.statusCode}');
              print('🚨 Response data: ${error.response?.data}');
            }
            handler.next(error);
          },
        ),
      );
    }
    return _dio!;
  }
}
