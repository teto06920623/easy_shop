import 'package:easy_shop/core/helpers/secure_storage_helper.dart';
import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_state.dart';
import 'package:easy_shop/features/auth/presentation/client/widgets/auto_collapsing_pill_button.dart';
import 'package:easy_shop/features/auth/presentation/client/widgets/merchant_onboarding_overlay.dart';
import 'package:easy_shop/features/auth/presentation/shared/cubit/auth_ui_cubit.dart';
import 'package:easy_shop/features/auth/presentation/shared/cubit/auth_ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientLoginScreen extends StatefulWidget {
  const ClientLoginScreen({super.key});

  @override
  State<ClientLoginScreen> createState() => _ClientLoginScreenState();
}

class _ClientLoginScreenState extends State<ClientLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final GlobalKey<AutoCollapsingPillButtonState> _merchantKey =
      GlobalKey<AutoCollapsingPillButtonState>();
  final GlobalKey<AutoCollapsingPillButtonState> _helpKey =
      GlobalKey<AutoCollapsingPillButtonState>();
  final GlobalKey _createAccountKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _checkAndShowOnboarding();
  }

  Future<void> _checkAndShowOnboarding() async {
    final hasSeen = await SecureStorageHelper.hasSeenOnboarding();
    if (!hasSeen && mounted) {
      await SecureStorageHelper.setOnboardingSeen();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        context.read<AuthUiCubit>().showGuide();
        await SecureStorageHelper.setOnboardingSeen();
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ClientAuthCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientAuthCubit, ClientAuthState>(
      listener: (context, state) {
        if (state is ClientAuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        } else if (state is ClientLoginSuccess) {
          Navigator.pushNamed(
            context,
            Routes.otpVerification,
            arguments: {
              'email': _emailController.text.trim(),
              'role': 'client',
            },
          );
        }
      },
      builder: (context, authState) {
        final isLoading = authState is ClientAuthLoading;

        return BlocBuilder<AuthUiCubit, AuthUiState>(
          builder: (context, uiState) {
            final authUiCubit = context.read<AuthUiCubit>();

            return Scaffold(
              backgroundColor: AppColors.background,
              body: Stack(
                children: [
                  SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoCollapsingPillButton(
                                  key: _helpKey,
                                  icon: Icons.help_outline_rounded,
                                  label: 'Help Guide',
                                  textColor: AppColors.textDark,
                                  onTap: () => authUiCubit.showGuide(),
                                ),
                                AutoCollapsingPillButton(
                                  key: _merchantKey,
                                  icon: Icons.storefront_outlined,
                                  label: 'Merchant Portal',
                                  textColor: AppColors.primary,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    Routes.adminLogin,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.shopping_bag_rounded,
                                        size: 42,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Welcome back',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Sign in to continue shopping',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    const SizedBox(height: 32),
                                    CustomTextField(
                                      label: 'Email',
                                      hint: 'you@example.com',
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                          ? 'Email is required'
                                          : null,
                                    ),
                                    const SizedBox(height: 18),
                                    CustomTextField(
                                      label: 'Password',
                                      hint: '••••••••',
                                      controller: _passwordController,
                                      isPassword: _obscurePassword,
                                      validator: (val) =>
                                          val == null || val.isEmpty
                                          ? 'Password is required'
                                          : null,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: AppColors.textMuted,
                                          size: 20,
                                        ),
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 28),
                                    CustomButton(
                                      title: 'Sign In',
                                      isLoading: isLoading,
                                      onPressed: _onSignIn,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      key: _createAccountKey,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "Don't have an account? ",
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 13,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => Navigator.pushNamed(
                                            context,
                                            Routes.clientRegister,
                                          ),
                                          child: const Text(
                                            'Create Account',
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (authUiCubit.isGuideVisible)
                    MerchantOnboardingOverlay(
                      merchantKey: _merchantKey,
                      createAccountKey: _createAccountKey,
                      onDismiss: () => authUiCubit.hideGuide(),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
