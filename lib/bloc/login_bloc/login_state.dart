part of 'login_bloc.dart';

class LoginState {
  final bool isLoading;
  final bool isSuccess;
  final bool otpSent;
  final String? error;
  final String mobileNumber;

  const LoginState({
    this.isLoading = false,
    this.isSuccess = false,
    this.otpSent = false,
    this.error,
    this.mobileNumber = '',
  });

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? otpSent,
    String? error,
    String? mobileNumber,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      otpSent: otpSent ?? this.otpSent,
      error: error ?? this.error,
      mobileNumber: mobileNumber ?? this.mobileNumber,
    );
  }
}
