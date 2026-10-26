import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shop/core/base_classes.dart';
import 'package:shop/core/error_handler.dart';

/// Network service interface
abstract class NetworkService {
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });
}

/// Dio-based network service implementation
class DioNetworkService implements NetworkService {
  final Dio _dio;

  DioNetworkService({required String baseUrl, Map<String, dynamic>? headers})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            ...?headers,
          },
        ),
      ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final token = await _getAuthToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          ErrorHandler.logError(error, error.stackTrace, 'NetworkService');

          final apiError = _handleDioError(error);
          return handler.reject(apiError);
        },
      ),
    ]);
  }

  Future<String?> _getAuthToken() async {
    // TODO: Implement token retrieval from secure storage
    return null;
  }

  DioException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: error.requestOptions,
          error: const NetworkException(
            'Connection timeout. Please check your internet connection.',
          ),
        );

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = _getErrorMessageFromResponse(error.response);

        switch (statusCode) {
          case 401:
            return DioException(
              requestOptions: error.requestOptions,
              error: UnauthorizedException(message),
            );
          case 400:
          case 422:
            return DioException(
              requestOptions: error.requestOptions,
              error: ValidationException(message),
            );
          default:
            return DioException(
              requestOptions: error.requestOptions,
              error: NetworkException(message, statusCode: statusCode),
            );
        }

      case DioExceptionType.cancel:
        return DioException(
          requestOptions: error.requestOptions,
          error: const NetworkException('Request cancelled'),
        );

      default:
        return DioException(
          requestOptions: error.requestOptions,
          error: const NetworkException('Network error occurred'),
        );
    }
  }

  String _getErrorMessageFromResponse(Response? response) {
    try {
      if (response?.data is Map<String, dynamic>) {
        final data = response!.data as Map<String, dynamic>;
        return data['message'] ?? data['error'] ?? 'Unknown error';
      }
      return response?.data?.toString() ?? 'Unknown error';
    } catch (e) {
      return 'Unknown error';
    }
  }

  @override
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(
        ErrorHandler.getErrorMessage(e.error),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(
        ErrorHandler.getErrorMessage(e.error),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(
        ErrorHandler.getErrorMessage(e.error),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(ErrorHandler.getErrorMessage(e));
    }
  }

  @override
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );

      return _handleResponse<T>(response, fromJson);
    } on DioException catch (e) {
      return ApiResponse.error(
        ErrorHandler.getErrorMessage(e.error),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return ApiResponse.error(ErrorHandler.getErrorMessage(e));
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    try {
      if (response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 300) {
        if (fromJson != null && response.data is Map<String, dynamic>) {
          final data = fromJson(response.data);
          return ApiResponse.success(data, statusCode: response.statusCode);
        }

        return ApiResponse.success(
          response.data as T,
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Request failed with status ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }
}
