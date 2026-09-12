class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? role;
  final String? token;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? pictureUrl;
  final String? businessName;
  final String? nationalId;
  final String? commercialRegister;
  final String? taxCard;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.role,
    this.token,
    this.address,
    this.latitude,
    this.longitude,
    this.pictureUrl,
    this.businessName,
    this.nationalId,
    this.commercialRegister,
    this.taxCard,
  });
}
