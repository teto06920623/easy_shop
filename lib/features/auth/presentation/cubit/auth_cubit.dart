import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthLoginSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthRegisterSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void verifyOtp({required String otp}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthOtpVerifiedSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  void resendOtp({required String email}) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      emit(AuthOtpSentSuccess());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
