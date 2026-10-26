import 'dependency_injection.dart';
export 'dependency_injection.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  static bool _initialized = false;

  factory ServiceLocator() {
    return _instance;
  }

  ServiceLocator._internal();

  void servicesLocator() {
    if (_initialized) return;
    _initialized = true;

    // Register network service
    getIt.registerLazySingleton<NetworkService>(
      () => DioNetworkService(baseUrl: 'https://api.yourapp.com'),
    );

    // Register repositories with proper dependencies
    getIt.registerLazySingleton<HomeRepository>(
      () => HomeHttpRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<ChatRepository>(
      () => ChatHttpRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<AuthRepository>(
      () => AuthHttpApiRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<MessageRepository>(
      () => MessageHttpRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<NotificationRepository>(
      () => NotificationHttpRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<UserRepository>(
      () => UserHttpRepository(getIt<NetworkService>()),
    );

    getIt.registerLazySingleton<PremiumRepository>(
      () => PremiumHttpRepository(getIt<NetworkService>()),
    );
  }
}
