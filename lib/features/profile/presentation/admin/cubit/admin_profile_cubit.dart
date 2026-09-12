import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../../../core/helpers/secure_storage_helper.dart'; 
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_admin_profile_usecase.dart';
import 'admin_profile_state.dart';

class AdminProfileCubit extends Cubit<AdminProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateAdminProfileUseCase updateAdminProfileUseCase;

  AdminProfileCubit({
    required this.getProfileUseCase,
    required this.updateAdminProfileUseCase,
  }) : super(AdminProfileInitial());

  Future<void> getProfile() async {
    emit(AdminProfileLoading());

    final result = await getProfileUseCase(true);

    switch (result) {
      case Success(data: final user):
        emit(AdminProfileLoaded(user: user));
      case Err(failure: final failure):
        emit(AdminProfileError(message: failure.message));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    required String businessName,
    required String email,
    required String nationalId,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
    String? commercialRegisterPath,
    String? taxCardPath,
  }) async {
    emit(AdminProfileLoading());

    final result = await updateAdminProfileUseCase(
      UpdateAdminProfileParams(
        name: name,
        email: email,
        phone: phone,
        businessName: businessName,
        nationalId: nationalId, 
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
        commercialRegisterPath: commercialRegisterPath,
        taxCardPath: taxCardPath,
      ),
    );

    switch (result) {
      case Success(data: final user):
        emit(AdminProfileUpdateSuccess(user: user));
      case Err(failure: final failure):
        emit(AdminProfileError(message: failure.message));
    }
  }

  Future<void> logout() async {
    emit(AdminProfileLoading());
    await SecureStorageHelper.logout();
    emit(AdminLoggedOutSuccess());
  }
}
