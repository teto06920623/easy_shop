import '../../../../core/errors/result.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Result<ProfileEntity>> getProfile({required bool isAdmin});

  Future<Result<ProfileEntity>> updateClientProfile({
    required String name,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
    required String email,
  });

  Future<Result<ProfileEntity>> updateAdminProfile({
    required String name,
    required String email,
    required String phone,
    required String businessName,
    required String nationalId,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
    String? commercialRegisterPath,
    String? taxCardPath,
  });
}
