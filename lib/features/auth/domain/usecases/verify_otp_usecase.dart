import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpParams {
  final String email;
  final String otp;
  final String role;

  const VerifyOtpParams({
    required this.email,
    required this.otp,
    required this.role,
  });
}

class VerifyOtpUseCase implements UseCase<UserEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Result<UserEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(
      email: params.email,
      otp: params.otp,
      role: params.role,
    );
  }
}
