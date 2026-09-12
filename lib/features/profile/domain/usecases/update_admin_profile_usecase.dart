import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateAdminProfileParams {
  final String name;
  final String phone;
  final String email;
  final String businessName;
  final String nationalId;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? picturePath;
  final String? commercialRegisterPath;
  final String? taxCardPath;

  const UpdateAdminProfileParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.nationalId,
    this.address,
    this.latitude,
    this.longitude,
    this.picturePath,
    this.commercialRegisterPath,
    this.taxCardPath,
  });
}

class UpdateAdminProfileUseCase
    implements UseCase<ProfileEntity, UpdateAdminProfileParams> {
  final ProfileRepository repository;

  UpdateAdminProfileUseCase(this.repository);

  @override
  Future<Result<ProfileEntity>> call(UpdateAdminProfileParams params) {
    return repository.updateAdminProfile(
      name: params.name,
      phone: params.phone,
      email: params.email,
      businessName: params.businessName,
      nationalId: params.nationalId,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      picturePath: params.picturePath,
      commercialRegisterPath: params.commercialRegisterPath,
      taxCardPath: params.taxCardPath,
    );
  }
}
