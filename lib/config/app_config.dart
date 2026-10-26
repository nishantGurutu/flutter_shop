/// Application configuration constants
class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://api.yourapp.com';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const Duration cacheTimeout = Duration(minutes: 5);
  static const int maxCacheSize = 100;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme';
  static const String languageKey = 'language';

  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePushNotifications = true;

  // Validation Rules
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxBioLength = 500;
}

/// API Endpoints
class ApiEndpoints {
  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';

  // User
  static const String users = '/users';
  static String userById(String id) => '/users/$id';
  static const String currentUser = '/users/me';

  // Products
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String categories = '/categories';

  // Cart
  static const String cart = '/cart';
  static String cartItem(String id) => '/cart/$id';

  // Orders
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';

  // Professionals
  static const String professionals = '/professionals';
  static String professionalById(String id) => '/professionals/$id';

  // Bookings
  static const String bookings = '/bookings';
  static String bookingById(String id) => '/bookings/$id';
}

/// UI Constants
class UIConstants {
  // Spacing
  static const double xsSpacing = 4.0;
  static const double smSpacing = 8.0;
  static const double mdSpacing = 16.0;
  static const double lgSpacing = 24.0;
  static const double xlSpacing = 32.0;
  static const double xxlSpacing = 48.0;

  // Border Radius
  static const double smRadius = 4.0;
  static const double mdRadius = 8.0;
  static const double lgRadius = 12.0;
  static const double xlRadius = 16.0;
  static const double xxlRadius = 24.0;

  // Font Sizes
  static const double xsFontSize = 12.0;
  static const double smFontSize = 14.0;
  static const double mdFontSize = 16.0;
  static const double lgFontSize = 18.0;
  static const double xlFontSize = 20.0;
  static const double xxlFontSize = 24.0;
  static const double xxxlFontSize = 32.0;

  // Icon Sizes
  static const double smIconSize = 16.0;
  static const double mdIconSize = 24.0;
  static const double lgIconSize = 32.0;
  static const double xlIconSize = 48.0;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 150);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Elevation
  static const double smElevation = 2.0;
  static const double mdElevation = 4.0;
  static const double lgElevation = 8.0;
  static const double xlElevation = 16.0;
}

/// Validation Messages
class ValidationMessages {
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDontMatch = 'Passwords do not match';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String nameTooLong = 'Name cannot exceed 50 characters';
  static const String bioTooLong = 'Bio cannot exceed 500 characters';
}
