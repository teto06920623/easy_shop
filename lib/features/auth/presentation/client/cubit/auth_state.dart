import 'package:flutter/foundation.dart';
import '../../../domain/entities/user_entity.dart';

@immutable
abstract class ClientAuthState {}

class ClientAuthInitial extends ClientAuthState {}

class ClientAuthLoading extends ClientAuthState {}

class ClientLoginSuccess extends ClientAuthState {
  final Map<String, dynamic> responseData;
  ClientLoginSuccess({required this.responseData});
}

class ClientRegisterSuccess extends ClientAuthState {
  final Map<String, dynamic> responseData;
  ClientRegisterSuccess({required this.responseData});
}

class ClientOtpSentSuccess extends ClientAuthState {}

class ClientOtpVerifiedSuccess extends ClientAuthState {
  final UserEntity user;
  ClientOtpVerifiedSuccess({required this.user});
}

class ClientAuthError extends ClientAuthState {
  final String message;
  ClientAuthError({required this.message});
}
