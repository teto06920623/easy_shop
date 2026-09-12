import 'package:flutter/foundation.dart';

@immutable
abstract class AuthUiState {}

class AuthUiInitial extends AuthUiState {}

class AuthGuideOverlayState extends AuthUiState {
  final bool isVisible;
  AuthGuideOverlayState({required this.isVisible});
}
