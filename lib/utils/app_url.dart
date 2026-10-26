import 'package:shop/config/app_config.dart';

/// Application URLs and endpoints
class AppUrls {
  // Base URLs
  static const String baseUrl = AppConfig.baseUrl;
  static const String imageBaseUrl = '$baseUrl/images';
  static const String apiBaseUrl = '$baseUrl/api/v1';

  // Auth URLs
  static const String loginUrl = '$apiBaseUrl/auth/login';
  static const String registerUrl = '$apiBaseUrl/auth/register';
  static const String forgotPasswordUrl = '$apiBaseUrl/auth/forgot-password';
  static const String resetPasswordUrl = '$apiBaseUrl/auth/reset-password';
  static const String refreshTokenUrl = '$apiBaseUrl/auth/refresh';

  // User URLs
  static const String usersUrl = '$apiBaseUrl/users';
  static const String currentUserUrl = '$apiBaseUrl/users/me';
  static const String updateProfileUrl = '$apiBaseUrl/users/profile';
  static const String uploadAvatarUrl = '$apiBaseUrl/users/avatar';

  // Product URLs
  static const String productsUrl = '$apiBaseUrl/products';
  static const String categoriesUrl = '$apiBaseUrl/categories';
  static const String featuredProductsUrl = '$apiBaseUrl/products/featured';
  static const String searchProductsUrl = '$apiBaseUrl/products/search';

  // Cart URLs
  static const String cartUrl = '$apiBaseUrl/cart';
  static const String addToCartUrl = '$apiBaseUrl/cart/add';
  static const String removeFromCartUrl = '$apiBaseUrl/cart/remove';
  static const String updateCartUrl = '$apiBaseUrl/cart/update';
  static const String clearCartUrl = '$apiBaseUrl/cart/clear';

  // Order URLs
  static const String ordersUrl = '$apiBaseUrl/orders';
  static const String createOrderUrl = '$apiBaseUrl/orders/create';
  static const String orderHistoryUrl = '$apiBaseUrl/orders/history';

  // Professional URLs
  static const String professionalsUrl = '$apiBaseUrl/professionals';
  static const String professionalCategoriesUrl =
      '$apiBaseUrl/professionals/categories';

  // Booking URLs
  static const String bookingsUrl = '$apiBaseUrl/bookings';
  static const String createBookingUrl = '$apiBaseUrl/bookings/create';
  static const String bookingHistoryUrl = '$apiBaseUrl/bookings/history';

  // Chat URLs
  static const String chatsUrl = '$apiBaseUrl/chats';
  static const String messagesUrl = '$apiBaseUrl/messages';

  // Notification URLs
  static const String notificationsUrl = '$apiBaseUrl/notifications';
  static const String markAsReadUrl = '$apiBaseUrl/notifications/read';

  // Static helper methods
  static String getUserUrl(String userId) => '$usersUrl/$userId';
  static String getProductUrl(String productId) => '$productsUrl/$productId';
  static String getCategoryUrl(String categoryId) =>
      '$categoriesUrl/$categoryId';
  static String getOrderUrl(String orderId) => '$ordersUrl/$orderId';
  static String getProfessionalUrl(String professionalId) =>
      '$professionalsUrl/$professionalId';
  static String getBookingUrl(String bookingId) => '$bookingsUrl/$bookingId';
  static String getChatUrl(String chatId) => '$chatsUrl/$chatId';

  // Image URLs
  static String getImageUrl(String imagePath) => '$imageBaseUrl/$imagePath';
  static String getAvatarUrl(String userId) =>
      '$imageBaseUrl/avatars/$userId.jpg';
  static String getProductImageUrl(String productId, [String? variant]) {
    return variant != null
        ? '$imageBaseUrl/products/$productId/$variant.jpg'
        : '$imageBaseUrl/products/$productId/main.jpg';
  }
}
