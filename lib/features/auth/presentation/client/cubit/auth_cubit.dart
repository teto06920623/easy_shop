import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_client_usecase.dart';
import '../../../domain/usecases/resend_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class ClientAuthCubit extends Cubit<ClientAuthState> {
  final LoginUseCase loginUseCase;
  final RegisterClientUseCase registerClientUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  ClientAuthCubit({
    required this.loginUseCase,
    required this.registerClientUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(ClientAuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(ClientAuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password, role: 'client'),
    );

    switch (result) {
      case Success(data: final data):
        emit(ClientLoginSuccess(responseData: data));
      case Err(failure: final failure):
        emit(ClientAuthError(message: failure.message));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    emit(ClientAuthLoading());

    final result = await registerClientUseCase(
      RegisterClientParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
      ),
    );

    switch (result) {
      case Success(data: final data):
        emit(ClientRegisterSuccess(responseData: data));
      case Err(failure: final failure):
        emit(ClientAuthError(message: failure.message));
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(ClientAuthLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: otp, role: 'client'),
    );

    switch (result) {
      case Success(data: final user):
        emit(ClientOtpVerifiedSuccess(user: user));
      case Err(failure: final failure):
        emit(ClientAuthError(message: failure.message));
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(ClientAuthLoading());

    final result = await resendOtpUseCase(
      ResendOtpParams(email: email, role: 'client'),
    );

    switch (result) {
      case Success():
        emit(ClientOtpSentSuccess());
      case Err(failure: final failure):
        emit(ClientAuthError(message: failure.message));
    }
  }
}
