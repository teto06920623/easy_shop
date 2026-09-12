import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class ResendOtpParams {
  final String email;
  final String role;

  const ResendOtpParams({required this.email, required this.role});
}

class ResendOtpUseCase implements UseCase<void, ResendOtpParams> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Result<void>> call(ResendOtpParams params) {
    return repository.resendOtp(email: params.email, role: params.role);
  }
}
