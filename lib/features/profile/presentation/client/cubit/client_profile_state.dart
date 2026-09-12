import 'package:flutter/foundation.dart';
import '../../../domain/entities/profile_entity.dart';

@immutable
abstract class ClientProfileState {}

class ClientProfileInitial extends ClientProfileState {}

class ClientProfileLoading extends ClientProfileState {}

class ClientProfileLoaded extends ClientProfileState {
  final ProfileEntity user;
  ClientProfileLoaded({required this.user});
}

class ClientProfileUpdateSuccess extends ClientProfileState {
  final ProfileEntity user;
  final String message;
  ClientProfileUpdateSuccess({
    required this.user,
    this.message = 'Profile updated successfully',
  });
}

class ClientLoggedOutSuccess extends ClientProfileState {}

class ClientProfileError extends ClientProfileState {
  final String message;
  ClientProfileError({required this.message});
}
