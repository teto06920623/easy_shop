import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: json['role'] ?? 'client',
      token:
          json['token'] ??
          json['access_token'] ??
          json['authorisation']?['token'],
      address: json['address'],
      latitude: json['latitude'] is double
          ? json['latitude']
          : double.tryParse(json['latitude']?.toString() ?? ''),
      longitude: json['longitude'] is double
          ? json['longitude']
          : double.tryParse(json['longitude']?.toString() ?? ''),
      pictureUrl: _buildImageUrl(json['picture_url'] ?? json['picture']),
      businessName: json['business_name'],
      nationalId: json['national_id'],
      commercialRegister: json['commercial_register'],
      taxCard: json['tax_card'],
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
      'token': token,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
