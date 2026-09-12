import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/errors/result.dart';
import '../../../../../core/helpers/secure_storage_helper.dart';
import '../../../domain/usecases/get_profile_usecase.dart';
import '../../../domain/usecases/update_client_profile_usecase.dart';
import 'client_profile_state.dart';

class ClientProfileCubit extends Cubit<ClientProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateClientProfileUseCase updateClientProfileUseCase;

  ClientProfileCubit({
    required this.getProfileUseCase,
    required this.updateClientProfileUseCase,
  }) : super(ClientProfileInitial());

  Future<void> getProfile() async {
    emit(ClientProfileLoading());

    final result = await getProfileUseCase(false);

    switch (result) {
      case Success(data: final user):
        emit(ClientProfileLoaded(user: user));
      case Err(failure: final failure):
        emit(ClientProfileError(message: failure.message));
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
    String? picturePath,
  }) async {
    emit(ClientProfileLoading());

    final result = await updateClientProfileUseCase(
      UpdateClientProfileParams(
        email: email,
        name: name,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
        picturePath: picturePath,
      ),
    );

    switch (result) {
      case Success(data: final user):
        emit(ClientProfileUpdateSuccess(user: user));
      case Err(failure: final failure):
        emit(ClientProfileError(message: failure.message));
    }
  }

  Future<void> logout() async {
    emit(ClientProfileLoading());
    await SecureStorageHelper.logout();
    emit(ClientLoggedOutSuccess());
  }
}
