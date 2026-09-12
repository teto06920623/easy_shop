import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(resetOnError: true),
  );

  static const String _userAddressKey = 'USER_ADDRESS';
  static const String _userLatKey = 'USER_LATITUDE';
  static const String _userLngKey = 'USER_LONGITUDE';

  static Future<void> saveUserAddress(String address) async {
    await _storage.write(key: _userAddressKey, value: address);
  }

  static Future<String?> getUserAddress() async {
    return await _storage.read(key: _userAddressKey);
  }

  static Future<void> saveUserLocation(double lat, double lng) async {
    await _storage.write(key: _userLatKey, value: lat.toString());
    await _storage.write(key: _userLngKey, value: lng.toString());
  }

  static Future<double?> getUserLatitude() async {
    final val = await _storage.read(key: _userLatKey);
    return val != null ? double.tryParse(val) : null;
  }

  static Future<double?> getUserLongitude() async {
    final val = await _storage.read(key: _userLngKey);
    return val != null ? double.tryParse(val) : null;
  }

  static const String _userIdKey = 'USER_ID';

  static Future<void> saveUserId(int id) async {
    await _storage.write(key: _userIdKey, value: id.toString());
  }

  static Future<int?> getUserId() async {
    final val = await _storage.read(key: _userIdKey);
    return val != null ? int.tryParse(val) : null;
  }

  static Future<List<String>> getMerchantCategorySlugs(int adminId) async {
    final str = await _storage.read(key: 'MERCHANT_CATS_$adminId');
    if (str == null || str.isEmpty) return [];
    return str.split(',');
  }

  static Future<void> addMerchantCategorySlug(int adminId, String slug) async {
    final slugs = await getMerchantCategorySlugs(adminId);
    if (!slugs.contains(slug)) {
      slugs.add(slug);
      await _storage.write(
        key: 'MERCHANT_CATS_$adminId',
        value: slugs.join(','),
      );
    }
  }

  static Future<void> removeMerchantCategorySlug(
    int adminId,
    String slug,
  ) async {
    final slugs = await getMerchantCategorySlugs(adminId);
    slugs.remove(slug);
    await _storage.write(key: 'MERCHANT_CATS_$adminId', value: slugs.join(','));
  }

  static const String _tokenKey = 'USER_AUTH_TOKEN';
  static const String _userRoleKey = 'USER_ROLE';
  static const String _onboardingKey = 'HAS_SEEN_ONBOARDING';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> saveUserRole(String role) async {
    await _storage.write(key: _userRoleKey, value: role);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _userRoleKey);
  }

  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userRoleKey);
  }

  static Future<void> clearAll() async {
    final hasSeen = await hasSeenOnboarding();
    await _storage.deleteAll();
    if (hasSeen) {
      await setOnboardingSeen();
    }
  }

  static Future<void> setOnboardingSeen() async {
    await _storage.write(key: _onboardingKey, value: 'true');
  }

  static Future<bool> hasSeenOnboarding() async {
    final value = await _storage.read(key: _onboardingKey);
    return value == 'true';
  }
}
