import '../../../../core/errors/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class GetProfileUseCase implements UseCase<ProfileEntity, bool> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Result<ProfileEntity>> call(bool isAdmin) {
    return repository.getProfile(isAdmin: isAdmin);
  }
}
