import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/register_merchant_usecase.dart';
import '../../../domain/usecases/resend_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import 'admin_auth_state.dart';

class AdminAuthCubit extends Cubit<AdminAuthState> {
  final LoginUseCase loginUseCase;
  final RegisterMerchantUseCase registerMerchantUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AdminAuthCubit({
    required this.loginUseCase,
    required this.registerMerchantUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(AdminAuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AdminAuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password, role: 'admin'),
    );

    switch (result) {
      case Success(data: final data):
        emit(AdminLoginSuccess(responseData: data));
      case Err(failure: final failure):
        emit(AdminAuthError(message: failure.message));
    }
  }

  Future<void> registerMerchant({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String nationalId,
    required String businessName,
    String? address,
    double? latitude,
    double? longitude,
    String? commercialRegisterPath,
    String? taxCardPath,
    String? picturePath,
  }) async {
    emit(AdminAuthLoading());

    final result = await registerMerchantUseCase(
      RegisterMerchantParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
        nationalId: nationalId,
        businessName: businessName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        commercialRegisterPath: commercialRegisterPath,
        taxCardPath: taxCardPath,
        picturePath: picturePath,
      ),
    );

    switch (result) {
      case Success(data: final data):
        emit(AdminRegisterSuccess(responseData: data));
      case Err(failure: final failure):
        emit(AdminAuthError(message: failure.message));
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(AdminAuthLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: otp, role: 'admin'),
    );

    switch (result) {
      case Success(data: final user):
        emit(AdminOtpVerifiedSuccess(user: user));
      case Err(failure: final failure):
        emit(AdminAuthError(message: failure.message));
    }
  }

  Future<void> resendOtp({required String email}) async {
    emit(AdminAuthLoading());

    final result = await resendOtpUseCase(
      ResendOtpParams(email: email, role: 'admin'),
    );

    switch (result) {
      case Success():
        emit(AdminOtpSentSuccess());
      case Err(failure: final failure):
        emit(AdminAuthError(message: failure.message));
    }
  }
}
