import 'dart:io';
import 'package:easy_shop/core/helpers/secure_storage_helper.dart';
import 'package:easy_shop/core/theme/app_colors.dart';
import 'package:easy_shop/core/widgets/custom_button.dart';
import 'package:easy_shop/features/maps/presentation/client/screens/map_picker_screen.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_cubit.dart';
import 'package:easy_shop/features/profile/presentation/client/cubit/client_profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  double? _latitude;
  double? _longitude;
  String? _localImagePath;
  bool _showSuccessBanner = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    final state = context.read<ClientProfileCubit>().state;
    final user = (state is ClientProfileLoaded)
        ? state.user
        : (state is ClientProfileUpdateSuccess ? state.user : null);

    if (user != null) {
      _nameController.text = user.name;
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
      _latitude = user.latitude;
      _longitude = user.longitude;
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'AH';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file != null) {
      setState(() => _localImagePath = file.path);
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
        _addressController.text = result.address;
      });
      
      await SecureStorageHelper.saveUserAddress(result.address);
      await SecureStorageHelper.saveUserLocation(
        result.latitude,
        result.longitude,
      );
    }
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email cannot be empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone cannot be empty'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (address.isNotEmpty) {
      SecureStorageHelper.saveUserAddress(address);
    }
    if (_latitude != null && _longitude != null) {
      SecureStorageHelper.saveUserLocation(_latitude!, _longitude!);
    }

    context.read<ClientProfileCubit>().updateProfile(
      name: name,
      email: email,
      phone: phone,
      address: address.isNotEmpty ? address : null,
      latitude: _latitude,
      longitude: _longitude,
      picturePath: _localImagePath,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocConsumer<ClientProfileCubit, ClientProfileState>(
        listener: (context, state) {
          if (state is ClientProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ClientProfileUpdateSuccess ||
              state is ClientProfileLoaded) {
            setState(() {
              _showSuccessBanner = true;
            });
          }
        },
        builder: (context, state) {
          final isLoading = state is ClientProfileLoading;
          final user = (state is ClientProfileLoaded)
              ? state.user
              : (state is ClientProfileUpdateSuccess ? state.user : null);

          final initials = _getInitials(
            _nameController.text.isNotEmpty
                ? _nameController.text
                : (user?.name ?? 'AH'),
          );
          final serverPicture = user?.pictureUrl;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: AppColors.primary,
                          backgroundImage: _localImagePath != null
                              ? FileImage(File(_localImagePath!))
                                    as ImageProvider
                              : (serverPicture != null &&
                                    serverPicture.isNotEmpty)
                              ? NetworkImage(serverPicture)
                              : null,
                          child:
                              (_localImagePath == null &&
                                  (serverPicture == null ||
                                      serverPicture.isEmpty))
                              ? Text(
                                  initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  
                  _buildFieldLabel('Full Name'),
                  _buildInputBox(
                    controller: _nameController,
                    hint: 'Ahmed Hassan',
                  ),

                  const SizedBox(height: 16),

                  
                  _buildFieldLabel('Email'),
                  _buildInputBox(
                    controller: _emailController,
                    hint: 'ahmed@example.com',
                    readOnly: true,
                  ),

                  const SizedBox(height: 16),

                  
                  _buildFieldLabel('Phone'),
                  _buildInputBox(
                    controller: _phoneController,
                    hint: '+20 100 000 0000',
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 16),

                  
                  _buildFieldLabel('Address'),
                  _buildInputBox(
                    controller: _addressController,
                    hint: '123 Tahrir Square, Cairo, Egypt',
                  ),

                  const SizedBox(height: 14),

                  
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _pickLocationFromMap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF7F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFFFD8C2)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Location — tap to update on map',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  
                  if (_showSuccessBanner) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF8EE),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFB7EBC9)),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(0xFF2E7D32),
                            size: 20,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Profile saved successfully!',
                            style: TextStyle(
                              color: Color(0xFF2E7D32),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  
                  CustomButton(
                    title: 'Save Changes',
                    isLoading: isLoading,
                    onPressed: _onSave,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
        filled: true,
        fillColor: readOnly ? const Color(0xFFF7F7F7) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
