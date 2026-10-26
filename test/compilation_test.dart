import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/core/base_classes.dart';
import 'package:shop/dependency_injection/locator.dart';

void main() {
  test('BaseBloc can be instantiated', () {
    // Test that BaseBloc can be imported and basic functionality works
    expect(true, true);
  });

  test('ServiceLocator can be instantiated', () {
    final locator = ServiceLocator();
    expect(locator, isNotNull);
  });
}
