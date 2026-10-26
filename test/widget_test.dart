// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop/core/base_classes.dart';

void main() {
  test('BaseState works correctly', () {
    final state = TestState();
    expect(state.isLoading, false);
    expect(state.error, null);

    final newState = state.copyWith(isLoading: true, error: 'test error');
    expect(newState.isLoading, true);
    expect(newState.error, 'test error');
  });

  test('BaseEvent works correctly', () {
    final event = TestEvent();
    expect(event.props, []);
  });
}

class TestState extends BaseState {
  const TestState({super.isLoading, super.error});

  @override
  TestState copyWith({bool? isLoading, String? error}) {
    return TestState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [isLoading, error];
}

class TestEvent extends BaseEvent {
  const TestEvent();
}
