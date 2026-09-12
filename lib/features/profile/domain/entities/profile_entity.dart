import '../../../auth/domain/entities/user_entity.dart';

class ProfileEntity extends UserEntity {
  const ProfileEntity({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.role,
    super.token,
    super.address,
    super.latitude,
    super.longitude,
    super.pictureUrl,
    super.businessName,
    super.nationalId,
    super.commercialRegister,
    super.taxCard,
  });
}
