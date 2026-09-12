

import 'dart:io';
import 'package:easy_shop/core/helpers/location_helper.dart';
import 'package:easy_shop/core/routing/routes.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/auth/presentation/admin/cubit/admin_auth_cubit.dart';
import 'package:easy_shop/features/auth/presentation/admin/cubit/admin_auth_state.dart';
import 'package:easy_shop/features/maps/presentation/client/screens/map_picker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/admin_register_step_indicator.dart';
import '../widgets/step1_personal_info_widget.dart';
import '../widgets/step2_business_info_widget.dart';
import '../widgets/step3_security_widget.dart';

class AdminRegisterScreen extends StatefulWidget {
  const AdminRegisterScreen({super.key});

  @override
  State<AdminRegisterScreen> createState() => _AdminRegisterScreenState();
}

class _AdminRegisterScreenState extends State<AdminRegisterScreen> {
  int _currentStep = 1;
  final _picker = ImagePicker();

  
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalIdController = TextEditingController();

  
  final _businessNameController = TextEditingController();
  final _businessAddressController = TextEditingController();
  String? _selectedLocationText;
  double? _latitude;
  double? _longitude;
  String? _commercialRegisterPath;
  String? _taxCardPath;

  
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _picturePath;
  bool _isFetchingLocation = false;
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    _businessNameController.dispose();
    _businessAddressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(Function(String path) onPicked) async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => onPicked(pickedFile.path));
    }
  }

  Future<void> _pickLocationFromMap() async {
    final result = await Navigator.push<MapPickerResult>(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _selectedLocationText =
            'Lat: ${_latitude!.toStringAsFixed(4)}, Lng: ${_longitude!.toStringAsFixed(4)}';
        if (_businessAddressController.text.trim().isEmpty) {
          _businessAddressController.text = result.address;
        }
      });
    }
  }

  Future<void> _fetchLocationDirectly() async {
    setState(() => _isFetchingLocation = true);
    final result = await LocationHelper.getCurrentCityAndLocation();
    setState(() => _isFetchingLocation = false);

    if (result != null) {
      setState(() {
        _latitude = result.latitude;
        _longitude = result.longitude;
        _selectedLocationText = result.cityName;
        if (_businessAddressController.text.trim().isEmpty) {
          _businessAddressController.text = result.cityName;
        }
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

  bool _validateCurrentStep() {
    if (_currentStep == 1) {
      if (_fullNameController.text.trim().isEmpty) {
        _showError('Full name is required');
        return false;
      }
      if (!_emailController.text.contains('@')) {
        _showError('Valid email is required');
        return false;
      }
      if (_phoneController.text.trim().isEmpty) {
        _showError('Phone number is required');
        return false;
      }
      if (_nationalIdController.text.trim().length < 14) {
        _showError('National ID must be 14 digits');
        return false;
      }
    } else if (_currentStep == 2) {
      if (_businessNameController.text.trim().isEmpty) {
        _showError('Business name is required');
        return false;
      }
    } else if (_currentStep == 3) {
      if (_passwordController.text.length < 6) {
        _showError('Password must be at least 6 characters');
        return false;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        _showError('Passwords do not match');
        return false;
      }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  void _onContinue() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      
      context.read<AdminAuthCubit>().registerMerchant(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        nationalId: _nationalIdController.text.trim(),
        businessName: _businessNameController.text.trim(),
        password: _passwordController.text,
        address: _businessAddressController.text.trim().isNotEmpty
            ? _businessAddressController.text.trim()
            : null,
        latitude: _latitude,
        longitude: _longitude,
        commercialRegisterPath: _commercialRegisterPath,
        taxCardPath: _taxCardPath,
        picturePath: _picturePath,
      );
    }
  }

  void _onBack() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminAuthCubit, AdminAuthState>(
      listener: (context, state) {
        if (state is AdminAuthError) {
          _showError(state.message);
        } else if (state is AdminRegisterSuccess) {
          Navigator.pushNamed(
            context,
            Routes.otpVerification,
            arguments: {'email': _emailController.text.trim(), 'role': 'admin'},
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AdminAuthLoading;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textDark,
              ),
              onPressed: _onBack,
            ),
            title: const Text(
              'Create Merchant Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AdminRegisterStepIndicator(currentStep: _currentStep),
                  const SizedBox(height: 24),

                  if (_currentStep == 1)
                    Step1PersonalInfoWidget(
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      nationalIdController: _nationalIdController,
                    ),

                  if (_currentStep == 2)
                    Step2BusinessInfoWidget(
                      businessNameController: _businessNameController,
                      businessAddressController: _businessAddressController,
                      selectedLocation: _selectedLocationText,
                      isFetchingLocation: _isFetchingLocation,
                      onFetchCurrentLocation: _fetchLocationDirectly,
                      onPickLocation: _pickLocationFromMap,
                      uploadedCommercialRegister:
                          _commercialRegisterPath != null
                          ? _commercialRegisterPath!
                                .split(Platform.pathSeparator)
                                .last
                          : null,
                      uploadedTaxCard: _taxCardPath != null
                          ? _taxCardPath!.split(Platform.pathSeparator).last
                          : null,
                      onUploadCommercialRegister: () =>
                          _pickImage((path) => _commercialRegisterPath = path),
                      onRemoveCommercialRegister: () =>
                          setState(() => _commercialRegisterPath = null),
                      onUploadTaxCard: () =>
                          _pickImage((path) => _taxCardPath = path),
                      onRemoveTaxCard: () =>
                          setState(() => _taxCardPath = null),
                    ),

                  if (_currentStep == 3)
                    Step3SecurityWidget(
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      uploadedPicturePath: _picturePath,
                      onUploadPicture: () =>
                          _pickImage((path) => _picturePath = path),
                      onRemovePicture: () =>
                          setState(() => _picturePath = null),
                    ),

                  const SizedBox(height: 32),
                  CustomButton(
                    title: _currentStep == 3 ? 'Create Account' : 'Continue',
                    isLoading: isLoading,
                    onPressed: _onContinue,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
