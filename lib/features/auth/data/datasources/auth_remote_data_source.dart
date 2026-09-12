

import 'package:dio/dio.dart';
import 'package:easy_shop/core/helpers/file_upload_helper.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  });

  Future<Map<String, dynamic>> registerClient({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  });

  Future<Map<String, dynamic>> registerMerchant({
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

  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
    required String role,
  });

  Future<void> resendOtp({required String email, required String role});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final endpoint = role == 'admin'
        ? ApiConstants.adminLogin
        : ApiConstants.clientLogin;
    final response = await dio.post(
      endpoint,
      data: {'email': email, 'password': password},
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : {'data': response.data};
  }

  @override
  Future<Map<String, dynamic>> registerClient({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    final pictureFile = await FileUploadHelper.toMultipart(picturePath);

    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
      if (address != null && address.isNotEmpty) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (pictureFile != null) 'picture': pictureFile,
    });

    final response = await dio.post(
      ApiConstants.clientRegister,
      data: formData,
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : {'data': response.data};
  }

  @override
  Future<Map<String, dynamic>> registerMerchant({
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
  }) async {
    final commercialFile = await FileUploadHelper.toMultipart(
      commercialRegisterPath,
    );
    final taxCardFile = await FileUploadHelper.toMultipart(taxCardPath);
    final pictureFile = await FileUploadHelper.toMultipart(picturePath);

    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
      'national_id': nationalId,
      'business_name': businessName,
      if (address != null && address.isNotEmpty) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (commercialFile != null) 'commercial_register': commercialFile,
      if (taxCardFile != null) 'tax_card': taxCardFile,
      if (pictureFile != null) 'picture': pictureFile,
    });

    final response = await dio.post(ApiConstants.adminRegister, data: formData);
    return response.data is Map<String, dynamic>
        ? response.data
        : {'data': response.data};
  }

  @override
  Future<UserModel> verifyOtp({
    required String email,
    required String otp,
    required String role,
  }) async {
    final endpoint = role == 'admin'
        ? ApiConstants.adminVerifyOtp
        : ApiConstants.clientVerifyOtp;

    final response = await dio.post(
      endpoint,
      data: {'email': email, 'otp_code': otp},
    );

    final rawData = response.data;
    if (rawData is Map<String, dynamic>) {
      final userData = rawData['data'] ?? rawData['user'] ?? rawData;
      if (userData is Map<String, dynamic>) {
        final inner = userData['user'] is Map
            ? userData['user'] as Map<String, dynamic>
            : userData;
        if (!inner.containsKey('token') && rawData.containsKey('token')) {
          inner['token'] = rawData['token'];
        }
        return UserModel.fromJson(inner);
      }
    }
    return UserModel.fromJson({});
  }

  @override
  Future<void> resendOtp({required String email, required String role}) async {
    final endpoint = role == 'admin'
        ? ApiConstants.adminResendOtp
        : ApiConstants.clientResendOtp;
    await dio.post(endpoint, data: {'email': email});
  }
}
