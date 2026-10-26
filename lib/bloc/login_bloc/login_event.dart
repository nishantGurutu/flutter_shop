part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class MobileNumberChanged extends LoginEvent {
  final String mobileNumber;
  const MobileNumberChanged(this.mobileNumber);
}

class SendOtpRequested extends LoginEvent {
  const SendOtpRequested();
}

class GoogleLoginRequested extends LoginEvent {
  const GoogleLoginRequested();
}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;
  const LoginSubmitted({required this.email, required this.password});
}
