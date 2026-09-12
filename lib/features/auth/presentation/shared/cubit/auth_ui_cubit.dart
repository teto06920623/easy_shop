import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_ui_state.dart';

class AuthUiCubit extends Cubit<AuthUiState> {
  AuthUiCubit() : super(AuthUiInitial());

  bool isGuideVisible = false;

  void showGuide() {
    isGuideVisible = true;
    emit(AuthGuideOverlayState(isVisible: true));
  }

  void hideGuide() {
    isGuideVisible = false;
    emit(AuthGuideOverlayState(isVisible: false));
  }
}