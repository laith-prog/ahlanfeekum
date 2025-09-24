import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../network/dio_factory.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_usecase.dart';
import '../../features/auth/domain/usecases/verify_otp_usecase.dart';
import '../../features/auth/domain/usecases/google_sign_in_usecase.dart';
import '../../features/auth/domain/usecases/register_user_usecase.dart';
import '../../features/auth/domain/usecases/send_otp_phone_usecase.dart';
import '../../features/auth/domain/usecases/confirm_password_reset_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/cubit/registration_cubit.dart';
import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/rent_create/data/datasources/rent_create_remote_data_source.dart';
import '../../features/rent_create/data/repositories/rent_create_repository_impl.dart';
import '../../features/rent_create/domain/repositories/rent_create_repository.dart';
import '../../features/rent_create/domain/usecases/create_property_usecase.dart';
import '../../features/rent_create/presentation/bloc/rent_create_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  const secureStorage = FlutterSecureStorage();
  getIt.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);

  final dio = DioFactory.getDio();
  getIt.registerLazySingleton<Dio>(() => dio);

  // Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // Data sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: getIt()),
  );

  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(getIt(), getIt()),
  );

  getIt.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt()),
  );

  getIt.registerLazySingleton<RentCreateRemoteDataSource>(
    () => RentCreateRemoteDataSourceImpl(getIt()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      remoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<RentCreateRepository>(
    () => RentCreateRepositoryImpl(getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt()));
  getIt.registerLazySingleton(() => ConfirmPasswordResetUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpPhoneUseCase(getIt()));

  // Rent Create Use Cases
  getIt.registerLazySingleton(() => CreatePropertyStepOneUseCase(getIt()));
  getIt.registerLazySingleton(() => CreatePropertyStepTwoUseCase(getIt()));
  getIt.registerLazySingleton(() => UploadImagesUseCase(getIt()));
  getIt.registerLazySingleton(() => SetPriceUseCase(getIt()));
  getIt.registerLazySingleton(() => AddAvailabilityUseCase(getIt()));

  // BLoC
  getIt.registerFactory(
    () => AuthBloc(
      loginUseCase: getIt(),
      sendOtpUseCase: getIt(),
      verifyOtpUseCase: getIt(),
      googleSignInUseCase: getIt(),
      confirmPasswordResetUseCase: getIt(),
      authLocalDataSource: getIt(),
    ),
  );

  getIt.registerFactory(() => SearchBloc(
    searchRepository: getIt(),
    sharedPreferences: getIt(),
  ));

  getIt.registerFactory(() => HomeBloc(
    homeRepository: getIt(),
  ));

  getIt.registerFactory(() => RentCreateBloc(
    createPropertyStepOneUseCase: getIt(),
    createPropertyStepTwoUseCase: getIt(),
    uploadImagesUseCase: getIt(),
    setPriceUseCase: getIt(),
    addAvailabilityUseCase: getIt(),
  ));

  // Registration Cubit
  getIt.registerFactory(() => RegistrationCubit(getIt()));
}
