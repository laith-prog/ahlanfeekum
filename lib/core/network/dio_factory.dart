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
            options.headers['accept'] = 'text/plain';

            // Add Authorization header
            try {
              final sharedPreferences = getIt<SharedPreferences>();
              final token = sharedPreferences.getString(
                AppConstants.accessTokenKey,
              );

              // Debug logging (can be removed in production)
              if (kDebugMode) {
                print('🔍 Request: ${options.path}');
                print('🔍 Full URL: ${options.uri}');
                print('🔍 Method: ${options.method}');
                print('🔍 Data: ${options.data}');
                if (token != null) {
                  print('🔍 Token: ${_isPlaceholderToken(token) ? 'PLACEHOLDER' : 'JWT'}');
                  print('🔍 Token length: ${token.length}');
                  print('🔍 Token preview: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');
                }
              }

              if (token != null &&
                  token.isNotEmpty &&
                  !_isPlaceholderToken(token)) {
                options.headers['Authorization'] = 'Bearer $token';
                if (kDebugMode) {
                  print('🔑 Auth header added for: ${options.path}');
                }
              } else {
                print('⚠️ No valid auth token found for request: ${options.path}');
                print('⚠️ Token value: $token');
                print('⚠️ Token is null: ${token == null}');
                print('⚠️ Token is empty: ${token?.isEmpty ?? true}');
                print('⚠️ Token is placeholder: ${token != null ? _isPlaceholderToken(token) : 'N/A'}');
                // For endpoints that require authentication, we should handle this
                if (_requiresAuthentication(options.path)) {
                  print('🚨 Request requires authentication but no valid token available');
                }
              }
              
              // Print final headers after all modifications
              if (kDebugMode) {
                print('🔍 Final Headers: ${options.headers}');
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

              // Handle authentication and authorization errors
              if (error.response?.statusCode == 403) {
                print(
                  '🚨 403 Forbidden: User lacks permissions for ${error.requestOptions.path}',
                );
                print('🚨 This indicates a server-side permission issue');
                print(
                  '🚨 The user account may need additional roles or permissions',
                );
                _handleAuthenticationError();
              } else if (error.response?.statusCode == 401) {
                print(
                  '🚨 401 Unauthorized: Authentication required for ${error.requestOptions.path}',
                );
                _handleAuthenticationError();
              }
            }
            handler.next(error);
          },
        ),
      );
    }
    return _dio!;
  }

  // Helper method to check if token is a placeholder
  static bool _isPlaceholderToken(String token) {
    const placeholderTokens = [
      'otp_verified_token',
      'google_token',
      'password_reset_token',
    ];
    return placeholderTokens.contains(token);
  }

  // Helper method to check if endpoint requires authentication
  static bool _requiresAuthentication(String path) {
    // List of endpoints that require authentication
    const authenticatedEndpoints = [
      'lookups/governates',
      'lookups/property-types',
      'lookups/property-features',
      'properties/search-property',
      'properties/create-step-one',
      'properties/create-step-two',
      'properties/add-availability',
      'properties/upload-one-media',
      'properties/upload-medias',
      'properties/set-price',
    ];

    return authenticatedEndpoints.any((endpoint) => path.contains(endpoint));
  }

  // Handle authentication errors by clearing invalid tokens
  static void _handleAuthenticationError() {
    try {
      final sharedPreferences = getIt<SharedPreferences>();
      final token = sharedPreferences.getString(AppConstants.accessTokenKey);

      if (token != null && _isPlaceholderToken(token)) {
        print('🧹 Clearing invalid placeholder token: $token');
        sharedPreferences.remove(AppConstants.accessTokenKey);
        sharedPreferences.remove(AppConstants.refreshTokenKey);
        sharedPreferences.remove(AppConstants.userDataKey);
        sharedPreferences.remove(AppConstants.isLoggedInKey);
      } else if (token != null) {
        print(
          '🔍 Valid JWT token found, not clearing. Permission issue is server-side.',
        );
        print('🔍 Token preview: ${token.substring(0, 20)}...');
      }
    } catch (e) {
      print('🚨 Error handling authentication error: $e');
    }
  }
}
