import 'package:flutter/foundation.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthOtpSentSuccess extends AuthState {}

class AuthOtpVerifiedSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
