import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:shop/data/network/base_api_services.dart';
import 'package:shop/services/storage/local_storage.dart';
import 'package:flutter/foundation.dart';
import '../exception/app_exceptions.dart';

class NetworkApiService implements BaseApiServices {
  late final Dio _dio;

  NetworkApiService() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageHelper.getJwtToken();
          if (token != null && token.isNotEmpty) {
            options.headers['token'] = token;
          }
          options.headers['Content-Type'] = 'application/json';
          if (kDebugMode) {
            print("➡️ REQUEST [${options.method}] => ${options.uri}");
            print("Headers: ${options.headers}");
            print("Body: ${options.data}");
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            log("✅ RESPONSE [${response.statusCode}] => ${response.data}");
          }
          handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print("❌ ERROR => ${e.message}");
          }
          handler.next(e);
        },
      ),
    );
  }

  @override
  Future<dynamic> getApi(String url) async {
    try {
      final response = await _dio.get(url);
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw NoInternetException('No Internet');
    }
  }

  @override
  Future<dynamic> postApi(String url, dynamic data) async {
    try {
      final response = await _dio.post(url, data: data);
      return _returnResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw NoInternetException('No Internet');
    }
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
        throw UnauthorisedException("Unauthorized request");
      case 404:
        throw FetchDataException("API not found");
      case 500:
        throw FetchDataException("Server error");
      default:
        throw FetchDataException(
          "Error with status code ${response.statusCode}",
        );
    }
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return FetchDataException("Request timeout");
      case DioExceptionType.connectionError:
        return NoInternetException("No Internet connection");
      default:
        return FetchDataException("Unexpected error occurred");
    }
  }
}
