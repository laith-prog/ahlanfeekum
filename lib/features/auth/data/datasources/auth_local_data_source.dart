import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUserData(UserModel user);
  Future<void> saveTokens(String accessToken, String? refreshToken);
  Future<UserModel?> getUserData();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> setLoggedIn(bool isLoggedIn);
  Future<bool> isLoggedIn();
  Future<void> clearUserData();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl(this.sharedPreferences, this.secureStorage);

  @override
  Future<void> saveUserData(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw CacheException('Failed to save user data: $e');
    }
  }

  @override
  Future<void> saveTokens(String accessToken, String? refreshToken) async {
    try {
      await secureStorage.write(
        key: AppConstants.accessTokenKey,
        value: accessToken,
      );

      if (refreshToken != null) {
        await secureStorage.write(
          key: AppConstants.refreshTokenKey,
          value: refreshToken,
        );
      }
    } catch (e) {
      throw CacheException('Failed to save tokens: $e');
    }
  }

  @override
  Future<UserModel?> getUserData() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get user data: $e');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await secureStorage.read(key: AppConstants.accessTokenKey);
    } catch (e) {
      throw CacheException('Failed to get access token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return await secureStorage.read(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to get refresh token: $e');
    }
  }

  @override
  Future<void> setLoggedIn(bool isLoggedIn) async {
    try {
      await sharedPreferences.setBool(AppConstants.isLoggedInKey, isLoggedIn);
    } catch (e) {
      throw CacheException('Failed to set login status: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
    } catch (e) {
      throw CacheException('Failed to get login status: $e');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
      await sharedPreferences.remove(AppConstants.isLoggedInKey);
      await secureStorage.delete(key: AppConstants.accessTokenKey);
      await secureStorage.delete(key: AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException('Failed to clear user data: $e');
    }
  }
}
