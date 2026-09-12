import 'package:flutter/foundation.dart';
import '../../../domain/entities/profile_entity.dart';

@immutable
abstract class AdminProfileState {}

class AdminProfileInitial extends AdminProfileState {}

class AdminProfileLoading extends AdminProfileState {}

class AdminProfileLoaded extends AdminProfileState {
  final ProfileEntity user;
  AdminProfileLoaded({required this.user});
}

class AdminProfileUpdateSuccess extends AdminProfileState {
  final ProfileEntity user;
  final String message;
  AdminProfileUpdateSuccess({
    required this.user,
    this.message = 'Merchant profile updated successfully',
  });
}

class AdminLoggedOutSuccess extends AdminProfileState {}

class AdminProfileError extends AdminProfileState {
  final String message;
  AdminProfileError({required this.message});
}
