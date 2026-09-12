import 'package:easy_shop/core/helpers/location_helper.dart';
import 'package:easy_shop/core/helpers/secure_storage_helper.dart';
import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/core/widgets/custom_text_field.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/client/cubit/auth_state.dart';
import 'package:easy_shop/features/maps/presentation/client/screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/client_address_picker_field.dart';
import '../widgets/client_password_fields.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  double? _selectedLatitude;
  double? _selectedLongitude;
  bool _isFetchingLocation = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocationDirectly() async {
    setState(() => _isFetchingLocation = true);
    final result = await LocationHelper.getCurrentCityAndLocation();
    setState(() => _isFetchingLocation = false);

    if (result != null) {
      setState(() {
        _addressController.text = result.cityName;
        _selectedLatitude = result.latitude;
        _selectedLongitude = result.longitude;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location detected: ${result.cityName}'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final addressText = _addressController.text.trim();

      if (addressText.isNotEmpty) {
        await SecureStorageHelper.saveUserAddress(addressText);
      }
      if (_selectedLatitude != null && _selectedLongitude != null) {
        await SecureStorageHelper.saveUserLocation(
          _selectedLatitude!,
          _selectedLongitude!,
        );
      }

      if (!mounted) return;

      context.read<ClientAuthCubit>().register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        address: addressText.isNotEmpty ? addressText : null,
        latitude: _selectedLatitude,
        longitude: _selectedLongitude,
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
        } else if (state is ClientRegisterSuccess) {
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
      builder: (context, state) {
        final isLoading = state is ClientAuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textDark,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: 'Full Name *',
                      hint: 'Taha Mohamed',
                      controller: _nameController,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Name is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Email *',
                      hint: 'teto06920623@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) => val == null || !val.contains('@')
                          ? 'Valid email is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Phone *',
                      hint: '+20 100 000 0000',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => val == null || val.trim().isEmpty
                          ? 'Phone is required'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        ClientAddressPickerField(
                          addressController: _addressController,
                          onFetchCurrentLocation: _fetchLocationDirectly,
                          onOpenMap: () async {
                            final result =
                                await Navigator.push<MapPickerResult>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MapPickerScreen(),
                                  ),
                                );
                            if (result != null) {
                              setState(() {
                                _addressController.text = result.address;
                                _selectedLatitude = result.latitude;
                                _selectedLongitude = result.longitude;
                              });
                            }
                          },
                        ),
                        if (_isFetchingLocation)
                          const Positioned(
                            top: 36,
                            right: 48,
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClientPasswordFields(
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                    ),
                    const SizedBox(height: 28),
                    CustomButton(
                      title: 'Create Account',
                      isLoading: isLoading,
                      onPressed: _onRegister,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
