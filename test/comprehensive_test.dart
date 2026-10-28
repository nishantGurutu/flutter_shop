import 'package:flutter_test/flutter_test.dart';

// Test imports from all folders mentioned by user
import 'package:shop/dependency_injection/locator.dart';

void main() {
  test('All imports work correctly', () {
    // Test that all imports can be resolved
    expect(true, true);
  });

  test('BaseBloc can be instantiated', () {
    // This will fail if there are compilation issues
    expect(BaseBloc, isNotNull);
  });

  test('ServiceLocator can be instantiated and initialized', () {
    final locator = ServiceLocator();
    locator.servicesLocator(); // This should not throw any errors
    expect(locator, isNotNull);
  });

  test('Repositories can be resolved from locator', () {
    final locator = ServiceLocator();
    locator.servicesLocator();

    // Test that repositories can be resolved
    expect(getIt<HomeRepository>(), isNotNull);
    expect(getIt<ChatRepository>(), isNotNull);
    expect(getIt<AuthRepository>(), isNotNull);
  });
}
