import 'package:shop/config/app_config.dart';

/// Utility class for input validation
class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.requiredField;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return ValidationMessages.invalidEmail;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.requiredField;
    }

    if (value.length < AppConfig.minPasswordLength) {
      return ValidationMessages.passwordTooShort;
    }

    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.requiredField;
    }

    if (value != originalPassword) {
      return ValidationMessages.passwordsDontMatch;
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.requiredField;
    }

    // Remove all non-digit characters for validation
    final cleanNumber = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid phone number (10-15 digits)
    if (cleanNumber.length < 10 || cleanNumber.length > 15) {
      return ValidationMessages.invalidPhoneNumber;
    }

    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationMessages.requiredField;
    }

    if (value.length > AppConfig.maxNameLength) {
      return ValidationMessages.nameTooLong;
    }

    // Check for valid name characters (letters, spaces, hyphens, apostrophes)
    final nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    return null;
  }

  static String? validateBio(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Bio is optional
    }

    if (value.length > AppConfig.maxBioLength) {
      return ValidationMessages.bioTooLong;
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName ${ValidationMessages.requiredField.toLowerCase()}';
    }
    return null;
  }

  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, fieldName);
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, fieldName);
    }

    if (value.length > maxLength) {
      return '$fieldName cannot exceed $maxLength characters';
    }

    return null;
  }

  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, fieldName);
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName must be a valid number';
    }

    return null;
  }

  static String? validatePositiveNumber(String? value, String fieldName) {
    final numericError = validateNumeric(value, fieldName);
    if (numericError != null) {
      return numericError;
    }

    final number = double.parse(value!);
    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }

  static String? validateUrl(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return validateRequired(value, fieldName);
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid $fieldName URL';
    }

    return null;
  }
}

/// Extension methods for form validation
extension ValidationExtensions on String {
  String? get isValidEmail => Validators.validateEmail(this);
  String? get isValidPassword => Validators.validatePassword(this);
  String? get isValidPhoneNumber => Validators.validatePhoneNumber(this);
  String? get isValidName => Validators.validateName(this);
  String? get isValidBio => Validators.validateBio(this);

  bool get isValidEmailBool => isValidEmail == null;
  bool get isValidPasswordBool => isValidPassword == null;
  bool get isValidPhoneNumberBool => isValidPhoneNumber == null;
  bool get isValidNameBool => isValidNameBool == null;
  bool get isValidBioBool => isValidBio == null;
}
