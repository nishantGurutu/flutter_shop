import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:shop/core/base_classes.dart';

/// Centralized error handling utility
class ErrorHandler {
  static void logError(
    dynamic error, [
    StackTrace? stackTrace,
    String? context,
  ]) {
    developer.log(
      'Error${context != null ? ' in $context' : ''}: $error',
      error: error,
      stackTrace: stackTrace,
      name: 'ErrorHandler',
    );
  }

  static String getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Network error: ${error.message}';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is UnauthorizedException) {
      return 'Authentication required. Please log in again.';
    } else if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    } else {
      return 'An unexpected error occurred';
    }
  }

  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showErrorDialog(
    BuildContext context,
    String title,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Extension on BuildContext for easy error handling
extension ErrorHandling on BuildContext {
  void showErrorSnackBar(String message) {
    ErrorHandler.showSnackBar(this, message, isError: true);
  }

  void showSuccessSnackBar(String message) {
    ErrorHandler.showSnackBar(this, message, isError: false);
  }

  void showErrorDialog(String title, String message) {
    ErrorHandler.showErrorDialog(this, title, message);
  }
}
