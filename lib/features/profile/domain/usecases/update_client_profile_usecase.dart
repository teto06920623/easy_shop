import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateClientProfileParams {
  final String name;
  final String email;
  final String phone;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? picturePath;

  const UpdateClientProfileParams({
    required this.name,
    required this.email,
    required this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.picturePath,
  });
}

class UpdateClientProfileUseCase
    implements UseCase<ProfileEntity, UpdateClientProfileParams> {
  final ProfileRepository repository;

  UpdateClientProfileUseCase(this.repository);

  @override
  Future<Result<ProfileEntity>> call(UpdateClientProfileParams params) {
    return repository.updateClientProfile(
      email:params.email,
      name: params.name,
      phone: params.phone,
      address: params.address,
      latitude: params.latitude,
      longitude: params.longitude,
      picturePath: params.picturePath,
    );
  }
}
