import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_result.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/user_model.dart';
import '../models/register_user_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResult>> login({
    required String phoneOrEmail,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final request = LoginRequest(
          phoneOrEmail: phoneOrEmail,
          password: password,
        );

        final response = await remoteDataSource.login(request);

        if (response.code == 200 && response.data is LoginData) {
          final loginData = response.data as LoginData;
          // Create user from actual API response data
          final user = UserModel(
            id: loginData.userId ?? '1',
            email:
                loginData.email ??
                (phoneOrEmail.contains('@') ? phoneOrEmail : ''),
            name: loginData.name ?? 'User Name',
            phone:
                loginData.phone ??
                (!phoneOrEmail.contains('@') ? phoneOrEmail : null),
            isEmailVerified:
                true, // You might want to check this from API response
            isPhoneVerified:
                true, // You might want to check this from API response
          );

          final authResult = AuthResult(
            user: user,
            accessToken: loginData.accessToken ?? '',
          );

          // Save user data locally
          await localDataSource.saveUserData(user);
          await localDataSource.saveTokens(loginData.accessToken ?? '', null);
          await localDataSource.setLoggedIn(true);

          return Right(authResult);
        } else {
          return Left(AuthFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp({required String email}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendOtpEmail(email);

        if (response.code == 200) {
          return Right(response.data ?? 'OTP sent successfully');
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtpPhone({required String phone}) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.sendOtpPhone(phone);
        if (response.code == 200) {
          return Right(response.data ?? 'OTP sent successfully');
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.verifyOtp(email, otp);

        if (response.code == 200 && response.data == true) {
          // OTP verification successful, but we need to perform a login to get a valid token
          // For now, we'll clear any existing tokens and require the user to login properly
          await localDataSource.clearUserData();

          // Return success but don't save invalid tokens
          final user = UserModel(
            id: '1', // We don't get userId from OTP verification
            email: email,
            name: 'User Name', // We don't get name from OTP verification
            isEmailVerified: true,
            isPhoneVerified: true,
          );

          final authResult = AuthResult(
            user: user,
            accessToken:
                '', // No token - user needs to login after OTP verification
          );

          // Don't save login state - user needs to login after OTP verification
          return Right(authResult);
        } else {
          return Left(AuthFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Unexpected error: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? account = await googleSignIn.signIn();

      if (account != null) {
        // Get the Google authentication token
        final GoogleSignInAuthentication auth = await account.authentication;

        // TODO: Send Google token to your backend to exchange for your app's JWT token
        // For now, we'll clear tokens and require proper login
        await localDataSource.clearUserData();

        final user = UserModel(
          id: account.id,
          email: account.email,
          name: account.displayName ?? '',
          profileImage: account.photoUrl,
          isEmailVerified: true,
          isPhoneVerified: false,
        );

        final authResult = AuthResult(
          user: user,
          accessToken:
              '', // No token - need to implement Google token exchange with backend
        );

        // Don't save login state until we have a valid backend token
        return Right(authResult);
      } else {
        return const Left(AuthFailure('Google sign in cancelled'));
      }
    } catch (e) {
      return Left(AuthFailure('Google sign in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUserData();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUserData();
      return Right(user);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure('Failed to check login status: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthResult>> confirmPasswordReset({
    required String emailOrPhone,
    required String securityCode,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.confirmPasswordReset(
          emailOrPhone,
          securityCode,
          newPassword,
        );

        if (response.code == 200) {
          // Password reset successful, but user needs to login with new password to get valid token
          await localDataSource.clearUserData();

          final user = UserModel(
            id: '1',
            email: emailOrPhone,
            name: 'User Name',
            profileImage: null,
            isEmailVerified: true,
            isPhoneVerified: false,
          );

          final authResult = AuthResult(
            user: user,
            accessToken: '', // No token - user needs to login with new password
          );

          // Don't save login state - user needs to login with new password
          return Right(authResult);
        } else {
          return Left(ServerFailure(response.message));
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Password reset failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> registerUser(
    RegisterUserRequest request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.registerUser(request);
        if (response.code == 200) {
          return Right(response.message);
        }
        return Left(ServerFailure(response.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(UnknownFailure('Register user failed: $e'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
