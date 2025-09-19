class AppConstants {
  static const String baseUrl = 'http://srv954186.hstgr.cloud:5000/api/mobile/';

  // API Endpoints
  static const String loginEndpoint = 'auth/abp-login-url';
  static const String sendOtpEmailEndpoint =
      'user-profiles/send-secret-key-email';
  static const String sendOtpPhoneEndpoint =
      'user-profiles/send-secret-key-phone';
  static const String verifyOtpEndpoint = 'user-profiles/verify';
  static const String passwordResetRequestEndpoint =
      'user-profiles/password-reset-request';
  static const String confirmPasswordResetEndpoint =
      'user-profiles/confirm-password-reset';

  // Registration & Lookups
  static const String registerUserEndpoint = 'user-profiles/register-user';
  static const String propertyTypesEndpoint = 'lookups/property-types';
  static const String propertyFeaturesEndpoint = 'lookups/property-features';
  static const String governatesEndpoint = 'lookups/governates';
  
  // Search & Properties
  static const String searchPropertyEndpoint = 'properties/search-property';

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';
  static const String languageKey = 'language';

  // Validation
  static const int minPasswordLength = 6;
  static const int otpLength = 4;
  static const int otpResendTimeInSeconds = 60;

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const String defaultLanguage = 'en';

  // Google Sign In
  static const String googleClientId =
      'YOUR_GOOGLE_CLIENT_ID'; // Replace with actual client ID
}
