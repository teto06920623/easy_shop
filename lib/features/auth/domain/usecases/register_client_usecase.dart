import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterClientParams {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? picturePath;

  const RegisterClientParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.address,
    this.latitude,
    this.longitude,
    this.picturePath,
  });
}

class RegisterClientUseCase
    implements UseCase<Map<String, dynamic>, RegisterClientParams> {
  final AuthRepository repository;

  RegisterClientUseCase(this.repository);

  @override
  Future<Result<Map<String, dynamic>>> call(RegisterClientParams params) {
    return repository.registerClient(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      picturePath: params.picturePath,
    );
  }
}
