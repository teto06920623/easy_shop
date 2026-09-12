import 'package:easy_shop/core/helpers/secure_storage_helper.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Result<ProfileEntity>> getProfile({required bool isAdmin}) async {
    try {
      final user = await remoteDataSource.getProfile(isAdmin: isAdmin);
      await SecureStorageHelper.saveUserId(user.id);
      return Success(user);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<ProfileEntity>> updateAdminProfile({
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
    try {
      final user = await remoteDataSource.updateAdminProfile(
        name: name,
        phone: phone,
        email: email,
        businessName: businessName,
        nationalId: nationalId,
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
        commercialRegisterPath: commercialRegisterPath,
        taxCardPath: taxCardPath,
      );
      return Success(user);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<ProfileEntity>> updateClientProfile({
    required String name,
    required String phone,
    required String email,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    try {
      final user = await remoteDataSource.updateClientProfile(
        name: name,
        email: email,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
      );
      return Success(user);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
