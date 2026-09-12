import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

class RegisterMerchantParams {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String nationalId;
  final String businessName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? commercialRegisterPath;
  final String? taxCardPath;
  final String? picturePath;

  const RegisterMerchantParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.nationalId,
    required this.businessName,
    this.address,
    this.latitude,
    this.longitude,
    this.commercialRegisterPath,
    this.taxCardPath,
    this.picturePath,
  });
}

class RegisterMerchantUseCase
    implements UseCase<Map<String, dynamic>, RegisterMerchantParams> {
  final AuthRepository repository;

  RegisterMerchantUseCase(this.repository);

  @override
  Future<Result<Map<String, dynamic>>> call(RegisterMerchantParams params) {
    return repository.registerMerchant(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      nationalId: params.nationalId,
      businessName: params.businessName,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      commercialRegisterPath: params.commercialRegisterPath,
      taxCardPath: params.taxCardPath,
      picturePath: params.picturePath,
    );
  }
}
