import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/di/injection.dart';
import 'theming/app_theme.dart';
import 'features/auth/presentation/pages/initial_splash_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/search/presentation/bloc/search_event.dart';
import 'features/search/presentation/pages/search_screen.dart';
import 'features/search/presentation/pages/search_results_screen.dart';
import 'features/search/presentation/pages/filter_screen.dart';
import 'features/search/data/models/search_filter.dart';
import 'features/rent_create/presentation/pages/rent_create_flow_screen.dart';
import 'features/rent_create/presentation/bloc/rent_create_bloc.dart';
import 'features/navigation/presentation/pages/main_navigation_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize EasyLocalization
  await EasyLocalization.ensureInitialized();

  // Initialize dependencies
  await initializeDependencies();

  // Clear any invalid authentication tokens
  await _clearInvalidTokens();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

// Helper function to clear invalid authentication tokens
Future<void> _clearInvalidTokens() async {
  try {
    final authLocalDataSource = getIt<AuthLocalDataSource>();
    await authLocalDataSource.clearInvalidTokens();
  } catch (e) {
    print('🚨 Error clearing invalid tokens during app initialization: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(create: (context) => getIt<AuthBloc>()),
          ],
          child: MaterialApp(
            title: 'Ahlan Feekum',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            themeMode: ThemeMode.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: const InitialSplashScreen(),
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        );
      },
    );
  }
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    debugPrint('🔧 Navigating to: ${settings.name}');
    debugPrint('🔧 Route arguments: ${settings.arguments}');

    switch (settings.name) {
      case '/search':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: const SearchScreen(),
          ),
        );

      case '/search-results':
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: const SearchResultsScreen(),
          ),
        );

      case '/filter':
        final currentFilter = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: getIt<SearchBloc>(),
            child: FilterScreen(
              currentFilter: currentFilter?['filter'] ?? const SearchFilter(),
            ),
          ),
        );

      case '/rent-create':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<RentCreateBloc>()),
              BlocProvider(create: (_) => getIt<SearchBloc>()..add(const LoadLookupsEvent())),
            ],
            child: const RentCreateFlowScreen(),
          ),
        );

      case '/main-navigation':
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<HomeBloc>()..add(const LoadHomeDataEvent())),
              BlocProvider(create: (_) => getIt<SearchBloc>()),
            ],
            child: const MainNavigationScreen(),
          ),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => getIt<HomeBloc>()..add(const LoadHomeDataEvent()),
            child: const HomeScreen(),
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const InitialSplashScreen());
    }
  }
}
