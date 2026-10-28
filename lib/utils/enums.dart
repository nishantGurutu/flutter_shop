/// Application enums for type safety and consistency
library;

enum UserRole {
  customer('customer'),
  professional('professional'),
  admin('admin');

  const UserRole(this.value);
  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.customer,
    );
  }
}

enum ProductCategory {
  electronics('electronics'),
  clothing('clothing'),
  home('home'),
  sports('sports'),
  books('books'),
  beauty('beauty'),
  automotive('automotive'),
  other('other');

  const ProductCategory(this.value);
  final String value;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ProductCategory.other,
    );
  }

  String get displayName {
    switch (this) {
      case ProductCategory.electronics:
        return 'Electronics';
      case ProductCategory.clothing:
        return 'Clothing & Fashion';
      case ProductCategory.home:
        return 'Home & Garden';
      case ProductCategory.sports:
        return 'Sports & Outdoors';
      case ProductCategory.books:
        return 'Books & Media';
      case ProductCategory.beauty:
        return 'Beauty & Personal Care';
      case ProductCategory.automotive:
        return 'Automotive';
      case ProductCategory.other:
        return 'Other';
    }
  }
}

enum OrderStatus {
  pending('pending'),
  confirmed('confirmed'),
  processing('processing'),
  shipped('shipped'),
  delivered('delivered'),
  cancelled('cancelled'),
  refunded('refunded');

  const OrderStatus(this.value);
  final String value;

  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => OrderStatus.pending,
    );
  }

  bool get isActive =>
      this != OrderStatus.cancelled && this != OrderStatus.refunded;
  bool get isCompleted => this == OrderStatus.delivered;
}

enum PaymentStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  cancelled('cancelled'),
  refunded('refunded');

  const PaymentStatus(this.value);
  final String value;

  static PaymentStatus fromString(String value) {
    return PaymentStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PaymentStatus.pending,
    );
  }

  bool get isSuccessful => this == PaymentStatus.completed;
  bool get isFailed =>
      this == PaymentStatus.failed || this == PaymentStatus.cancelled;
}

enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  inProgress('in_progress'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  const BookingStatus(this.value);
  final String value;

  static BookingStatus fromString(String value) {
    return BookingStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => BookingStatus.pending,
    );
  }

  bool get isActive =>
      this == BookingStatus.pending ||
      this == BookingStatus.confirmed ||
      this == BookingStatus.inProgress;
  bool get isCompleted => this == BookingStatus.completed;
  bool get isCancelled =>
      this == BookingStatus.cancelled || this == BookingStatus.noShow;
}

enum NotificationType {
  order('order'),
  booking('booking'),
  message('message'),
  promotion('promotion'),
  system('system');

  const NotificationType(this.value);
  final String value;

  static NotificationType fromString(String value) {
    return NotificationType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => NotificationType.system,
    );
  }
}

enum ThemeMode {
  light('light'),
  dark('dark'),
  system('system');

  const ThemeMode(this.value);
  final String value;

  static ThemeMode fromString(String value) {
    return ThemeMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => ThemeMode.system,
    );
  }
}

enum Language {
  english('en'),
  spanish('es'),
  french('fr'),
  german('de'),
  italian('it'),
  portuguese('pt');

  const Language(this.value);
  final String value;

  static Language fromString(String value) {
    return Language.values.firstWhere(
      (lang) => lang.value == value,
      orElse: () => Language.english,
    );
  }

  String get displayName {
    switch (this) {
      case Language.english:
        return 'English';
      case Language.spanish:
        return 'Español';
      case Language.french:
        return 'Français';
      case Language.german:
        return 'Deutsch';
      case Language.italian:
        return 'Italiano';
      case Language.portuguese:
        return 'Português';
    }
  }
}

enum SortOrder {
  ascending('asc'),
  descending('desc');

  const SortOrder(this.value);
  final String value;

  static SortOrder fromString(String value) {
    return SortOrder.values.firstWhere(
      (order) => order.value == value,
      orElse: () => SortOrder.ascending,
    );
  }
}

enum HttpMethod {
  get('GET'),
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  const HttpMethod(this.value);
  final String value;
}
