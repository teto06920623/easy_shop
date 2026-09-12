import 'package:flutter/foundation.dart';
import '../../../domain/entities/user_entity.dart';

@immutable
abstract class AdminAuthState {}

class AdminAuthInitial extends AdminAuthState {}

class AdminAuthLoading extends AdminAuthState {}

class AdminLoginSuccess extends AdminAuthState {
  final Map<String, dynamic> responseData;
  AdminLoginSuccess({required this.responseData});
}

class AdminRegisterSuccess extends AdminAuthState {
  final Map<String, dynamic> responseData;
  AdminRegisterSuccess({required this.responseData});
}

class AdminOtpSentSuccess extends AdminAuthState {}

class AdminOtpVerifiedSuccess extends AdminAuthState {
  final UserEntity user;
  AdminOtpVerifiedSuccess({required this.user});
}

class AdminAuthError extends AdminAuthState {
  final String message;
  AdminAuthError({required this.message});
}
