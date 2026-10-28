import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Base state class that all BLoC states should extend
/// Provides common properties like loading, error states
abstract class BaseState extends Equatable {
  const BaseState({this.isLoading = false, this.error});

  final bool isLoading;
  final String? error;

  BaseState copyWith({bool? isLoading, String? error});

  @override
  List<Object?> get props => [isLoading, error];
}

/// Base event class for all BLoC events
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// Base BLoC class with common functionality
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  /// Helper method to emit loading state
  void emitLoading() {
    final newState = state.copyWith(isLoading: true, error: null) as State;
    emit(newState);
  }

  /// Helper method to emit success state
  void emitSuccess() {
    final newState = state.copyWith(isLoading: false, error: null) as State;
    emit(newState);
  }

  /// Helper method to emit error state
  void emitError(String error) {
    final newState = state.copyWith(isLoading: false, error: error) as State;
    emit(newState);
  }

  /// Helper method to handle async operations with error handling
  Future<void> handleAsyncOperation(
    Future<void> Function() operation, {
    String? errorMessage,
  }) async {
    try {
      emitLoading();
      await operation();
      emitSuccess();
    } catch (e) {
      emitError(errorMessage ?? e.toString());
    }
  }
}

/// Base repository interface with common CRUD operations
abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<T> create(T item);
  Future<T> update(String id, T item);
  Future<void> delete(String id);
}

/// Base API response model
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data, {int? statusCode}) {
    return ApiResponse(success: true, data: data, statusCode: statusCode);
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse(success: false, error: error, statusCode: statusCode);
  }
}

/// Custom exceptions for better error handling
class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException(this.message, {this.statusCode});

  @override
  String toString() => 'NetworkException: $message';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String> errors;

  const ValidationException(this.message, {this.errors = const {}});

  @override
  String toString() => 'ValidationException: $message';
}

class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException(this.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}
