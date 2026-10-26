import 'package:flutter_test/flutter_test.dart';
import 'package:shop/core/base_classes.dart';

void main() {
  test('BaseState copyWith works correctly', () {
    final state = TestState();
    final newState = state.copyWith(isLoading: true);

    expect(newState.isLoading, true);
    expect(newState.error, null);
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
