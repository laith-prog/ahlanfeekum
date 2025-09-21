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
// Property Rental Imports
import '../../features/property_rental/data/datasources/property_rental_remote_data_source.dart';
import '../../features/property_rental/data/repositories/property_rental_repository_impl.dart';
import '../../features/property_rental/domain/repositories/property_rental_repository.dart';
import '../../features/property_rental/domain/usecases/create_property_step_one_usecase.dart';
import '../../features/property_rental/domain/usecases/update_property_location_usecase.dart';
import '../../features/property_rental/domain/usecases/add_property_availability_usecase.dart';
import '../../features/property_rental/domain/usecases/upload_property_images_usecase.dart';
import '../../features/property_rental/domain/usecases/set_property_price_usecase.dart';
import '../../features/property_rental/presentation/bloc/property_rental_bloc.dart';

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

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );

  getIt.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: getIt()),
  );

  // Property Rental Data Sources
  getIt.registerLazySingleton<PropertyRentalRemoteDataSource>(
    () => PropertyRentalRemoteDataSourceImpl(getIt()),
  );

  // Property Rental Repositories
  getIt.registerLazySingleton<PropertyRentalRepository>(
    () => PropertyRentalRepositoryImpl(remoteDataSource: getIt()),
  );

  // Use cases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => VerifyOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt()));
  getIt.registerLazySingleton(() => ConfirmPasswordResetUseCase(getIt()));
  getIt.registerLazySingleton(() => RegisterUserUseCase(getIt()));
  getIt.registerLazySingleton(() => SendOtpPhoneUseCase(getIt()));

  // Property Rental Use Cases
  getIt.registerLazySingleton(() => CreatePropertyStepOneUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdatePropertyLocationUseCase(getIt()));
  getIt.registerLazySingleton(() => AddPropertyAvailabilityUseCase(getIt()));
  getIt.registerLazySingleton(() => UploadPropertyImagesUseCase(getIt()));
  getIt.registerLazySingleton(() => SetPropertyPriceUseCase(getIt()));

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

  getIt.registerFactory(
    () => SearchBloc(searchRepository: getIt(), sharedPreferences: getIt()),
  );

  getIt.registerFactory(() => HomeBloc(homeRepository: getIt()));

  getIt.registerFactory(
    () => PropertyRentalBloc(
      createPropertyStepOneUseCase: getIt(),
      updatePropertyLocationUseCase: getIt(),
      addPropertyAvailabilityUseCase: getIt(),
      uploadPropertyImagesUseCase: getIt(),
      setPropertyPriceUseCase: getIt(),
    ),
  );

  // Registration Cubit
  getIt.registerFactory(() => RegistrationCubit(getIt()));
}
