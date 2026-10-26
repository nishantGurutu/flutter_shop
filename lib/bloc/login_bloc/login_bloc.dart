import 'package:shop/repository/auth_api/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(const LoginState()) {
    on<MobileNumberChanged>((event, emit) {
      emit(state.copyWith(mobileNumber: event.mobileNumber));
    });

    on<SendOtpRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        // Simulate OTP sending - replace with actual API call
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isLoading: false, otpSent: true));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        // Simulate Google login - replace with actual implementation
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });

    on<LoginSubmitted>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));
      try {
        final success = await authRepository.login(event.email, event.password);
        if (success) {
          emit(state.copyWith(isLoading: false, isSuccess: true));
        } else {
          emit(state.copyWith(isLoading: false, error: "Invalid credentials"));
        }
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
      }
    });
  }
}
