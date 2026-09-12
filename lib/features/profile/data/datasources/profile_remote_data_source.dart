

import 'package:dio/dio.dart';
import '../../../../core/helpers/file_upload_helper.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_factory.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required bool isAdmin});

  Future<ProfileModel> updateClientProfile({
    required String name,
    required String email, 
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  });

  Future<ProfileModel> updateAdminProfile({
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

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio = DioFactory.getDio();

  @override
  Future<ProfileModel> getProfile({required bool isAdmin}) async {
    final endpoint = isAdmin
        ? ApiConstants.adminProfile
        : ApiConstants.clientProfile;
    final response = await dio.get(endpoint);

    final rawData = response.data;
    final userData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['user'] ?? rawData)
        : {};

    return ProfileModel.fromJson(userData as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateClientProfile({
    required String name,
    required String email,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    final pictureFile = await FileUploadHelper.toMultipart(picturePath);

    final formData = FormData.fromMap({
      '_method': 'PUT',
      'name': name,
      'email': email,
      'phone': phone,
      if (address != null && address.isNotEmpty) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (pictureFile != null) 'picture': pictureFile,
    });

    final response = await dio.post(
      ApiConstants.clientUpdateProfile,
      data: formData,
      queryParameters: {'_method': 'PUT'},
      options: Options(headers: {'X-HTTP-Method-Override': 'PUT'}),
    );

    final rawData = response.data;
    final userData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['user'] ?? rawData)
        : {};

    return ProfileModel.fromJson(userData as Map<String, dynamic>);
  }

  @override
  Future<ProfileModel> updateAdminProfile({
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
  }) async {
    final pictureFile = await FileUploadHelper.toMultipart(picturePath);
    final commercialFile = await FileUploadHelper.toMultipart(
      commercialRegisterPath,
    );
    final taxCardFile = await FileUploadHelper.toMultipart(taxCardPath);

    final formData = FormData.fromMap({
      '_method': 'PUT',
      'name': name,
      'email': email,
      'phone': phone,
      'business_name': businessName,
      'national_id': nationalId, 
      if (address != null && address.isNotEmpty) 'address': address,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (pictureFile != null) 'picture': pictureFile,
      if (commercialFile != null) 'commercial_register': commercialFile,
      if (taxCardFile != null) 'tax_card': taxCardFile,
    });

    final response = await dio.post(
      ApiConstants.adminUpdateProfile,
      data: formData,
      queryParameters: {'_method': 'PUT'},
      options: Options(headers: {'X-HTTP-Method-Override': 'PUT'}),
    );

    final rawData = response.data;
    final userData = rawData is Map<String, dynamic>
        ? (rawData['data'] ?? rawData['user'] ?? rawData)
        : {};

    return ProfileModel.fromJson(userData as Map<String, dynamic>);
  }
}
