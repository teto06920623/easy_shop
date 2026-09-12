import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  const ProfileModel({
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

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString(),
      role: json['role']?.toString() ?? 'client',
      token:
          json['token']?.toString() ??
          json['access_token']?.toString() ??
          json['authorisation']?['token']?.toString(),
      address: json['address']?.toString(),
      latitude: json['latitude'] is double
          ? json['latitude']
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: json['longitude'] is double
          ? json['longitude']
          : double.tryParse(json['longitude']?.toString() ?? ''),
      pictureUrl: _buildImageUrl(json['picture_url'] ?? json['picture']),
      businessName: json['business_name']?.toString(),
      nationalId: json['national_id']?.toString(),
      commercialRegister: json['commercial_register']?.toString(),
      taxCard: json['tax_card']?.toString(),
    );
  }

  static String? _buildImageUrl(dynamic value) {
    if (value == null) return null;
    final s = value.toString().trim();
    if (s.isEmpty) return null;
    if (s.startsWith('http')) return s;
    if (s.startsWith('/')) {
      return 'https://easylearn.devawy.com$s';
    }
    return 'https://easylearn.devawy.com/storage/$s';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'picture_url': pictureUrl,
      'business_name': businessName,
      'national_id': nationalId,
    };
  }
}
