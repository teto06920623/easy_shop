import '../../../../core/errors/result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
    required String role,
  });

  Future<Result<Map<String, dynamic>>> registerClient({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  });

  Future<Result<Map<String, dynamic>>> registerMerchant({
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
  });

  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
    required String role,
  });

  Future<Result<void>> resendOtp({required String email, required String role});
}
