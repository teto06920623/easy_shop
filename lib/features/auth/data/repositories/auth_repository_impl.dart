import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<Map<String, dynamic>>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
        role: role,
      );
      return Success(response);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> registerClient({
    required String name,
    required String email,
    required String phone,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    try {
      final response = await remoteDataSource.registerClient(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
      );
      return Success(response);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> registerMerchant({
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
    try {
      final response = await remoteDataSource.registerMerchant(
        name: name,
        email: email,
        phone: phone,
        password: password,
        nationalId: nationalId,
        businessName: businessName,
        address: address,
        latitude: latitude,
        longitude: longitude,
        commercialRegisterPath: commercialRegisterPath,
        taxCardPath: taxCardPath,
        picturePath: picturePath,
      );
      return Success(response);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<UserEntity>> verifyOtp({
    required String email,
    required String otp,
    required String role,
  }) async {
    try {
      final user = await remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
        role: role,
      );
      if (user.address != null && user.address!.isNotEmpty) {
        await SecureStorageHelper.saveUserAddress(user.address!);
      }
      if (user.latitude != null && user.longitude != null) {
        await SecureStorageHelper.saveUserLocation(
          user.latitude!,
          user.longitude!,
        );
      }

      if (user.token != null && user.token!.isNotEmpty) {
        await SecureStorageHelper.saveToken(user.token!);
      }
      await SecureStorageHelper.saveUserRole(role);
      await SecureStorageHelper.saveUserId(user.id);

      return Success(user);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }

  @override
  Future<Result<void>> resendOtp({
    required String email,
    required String role,
  }) async {
    try {
      await remoteDataSource.resendOtp(email: email, role: role);
      return const Success(null);
    } catch (error) {
      return Err(ErrorHandler.handle(error));
    }
  }
}
