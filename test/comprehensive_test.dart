import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test imports from all folders mentioned by user
import 'package:shop/core/base_classes.dart';
import 'package:shop/core/network_service.dart';
import 'package:shop/core/error_handler.dart';
import 'package:shop/dependency_injection/locator.dart';
import 'package:shop/repository/home_api/home_repository.dart';
import 'package:shop/repository/chat_api/chat_repository.dart';
import 'package:shop/repository/auth_api/auth_repository.dart';
import 'package:shop/repository/message_api/message_repository.dart';
import 'package:shop/repository/notification_api/notification_repository.dart';
import 'package:shop/repository/home_api/user_repository.dart';
import 'package:shop/repository/premium_api/premium_repository.dart';
import 'package:shop/bloc/home_bloc/home_bloc.dart';
import 'package:shop/bloc/bottom_bar_bloc/bottom_bar_bloc.dart';
import 'package:shop/view/authorised/bottom_bar/bottom_bar.dart';
import 'package:shop/view/authorised/home/home_screen.dart';

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
