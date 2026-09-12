import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;
  final String role;

  const LoginParams({
    required this.email,
    required this.password,
    required this.role,
  });
}

class LoginUseCase implements UseCase<Map<String, dynamic>, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<Map<String, dynamic>>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}
